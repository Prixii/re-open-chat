import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_event.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/message/message_event.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/network/group/group.dart';
import 'package:re_open_chat/network/group/types.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:re_open_chat/utils/image_utils.dart';
import 'package:re_open_chat/utils/sqlite/contact.dart';
import 'package:re_open_chat/utils/sqlite/group.dart';

part 'contact_manager_state.dart';
part 'contact_manager_bloc.freezed.dart';

class ContactManagerBloc
    extends Bloc<ContactManagerEvent, ContactManagerState> {
  ContactManagerBloc() : super(const _Initial()) {
    on<ToContactDetail>(_onToContactDetail);
    on<ContactsUpdate>(_onContactsUpdate);
    on<InitializeContactManager>(_onInitialize);
    on<GetAvatarById>(_onGetAvatarById);
    on<LogOutContactManager>(_onLogOutContactManager);
    on<AddContactsCache>(_onAddContactsCache);
    on<EditGroupData>(_onEditGroupData);
    on<UpdateContactProfile>(_onUpdateContactProfile);
    on<FetchGroupMembers>(_onFetchGroupMembers);
  }

  void _onInitialize(
    InitializeContactManager event,
    Emitter<ContactManagerState> emit,
  ) async {
    var contactData = await sqliteManager.loadAllContacts();
    final myGroupIdSet = await sqliteManager.getMyGroupsIdSet();
    messageBloc.add(const InitializeMessageBloc());
    emit(state.copyWith(
        contactsCache: contactData.$1,
        addedOnContactId: contactData.$2.toSet(),
        myGroupIdSet: myGroupIdSet));
    final avatarBase64Map = await _loadAllAvatar(contactData.$1);
    emit(state.copyWith(avatarBase64Map: avatarBase64Map));
  }

  Future<Map<int, String>> _loadAllAvatar(Map<int, Contact> contactMap) async {
    final avatarBase64Map = <int, String>{};
    final contactCacheSnapShot = {...contactMap};
    for (final contact in contactCacheSnapShot.values.toList()) {
      final avatarBase64 =
          await getImageBase64ById(contact.avatarId, isAvatar: true);
      avatarBase64Map[contact.id] = avatarBase64;
    }
    return avatarBase64Map;
  }

  void _onAddContactsCache(
    AddContactsCache event,
    Emitter<ContactManagerState> emit,
  ) async {
    final contactsSnapShot = {...state.contactsCache};
    for (var contact in event.contacts) {
      contactsSnapShot[contact.id] = contact;
    }
    emit(state.copyWith(contactsCache: contactsSnapShot));
  }

  Future<Contact?> getContactById(int id) async {
    var targetContact = state.contactsCache[id];
    if (targetContact == null) {
      targetContact = await sqliteManager.findContactById(id);
      if (targetContact != null) {
        add(AddContactsCache([targetContact]));
      }
    }
    return targetContact;
  }

  void _onGetAvatarById(
    GetAvatarById event,
    Emitter<ContactManagerState> emit,
  ) async {
    final contactId = event.id;
    if (state.avatarBase64Map[contactId] == null ||
        state.avatarBase64Map[contactId] == "") {
      var contact = await getContactById(contactId);
      if (contact == null) return;
      final String avatarBase64 =
          await getImageBase64ById(contact.avatarId, isAvatar: true);
      talker.debug('avatar base64: $avatarBase64');
      emit(state.copyWith(
        avatarBase64Map: {
          ...state.avatarBase64Map,
          event.id: avatarBase64,
        },
      ));
    }
  }

  void _onToContactDetail(
    ToContactDetail event,
    Emitter<ContactManagerState> emit,
  ) async {
    if (event.contactId == globalBloc.state.user.id) return;
    final contact = await getContactById(event.contactId);
    if (contact == null) return;
    if (Contact.isGroup(contact.id)) {
      add(FetchGroupMembers(contact.id));
    }
    final contactsCacheSnapshot = {...state.contactsCache};
    final oldContact = contactsCacheSnapshot[event.contactId];
    if (oldContact != contact) {
      sqliteManager.updateContactInfo([contact]);
      if (oldContact?.avatarId != contact.avatarId) {
        getImageBase64ById(contact.avatarId, isAvatar: true)
            .then((avatarBase64) {
          emit(state.copyWith(
            avatarBase64Map: {
              ...state.avatarBase64Map,
              contact.id: avatarBase64,
            },
          ));
        });
      }
    }
    contactsCacheSnapshot[event.contactId] = contact;

    emit(
      state.copyWith(
        groupId:
            event.fromGroup ? chatManagerBloc.state.currentContact?.id : null,
        contactsCache: contactsCacheSnapshot,
        detailedContact: contact,
      ),
    );
    router.goNamed('contact-detail');
  }

  void _onContactsUpdate(
    ContactsUpdate event,
    Emitter<ContactManagerState> emit,
  ) async {
    final contactMapSnapShot = {...state.contactsCache};
    final latestAddedOnContactId = <int>[];
    for (var contact in event.contacts) {
      contactMapSnapShot[contact.id] = contact;
      latestAddedOnContactId.add(contact.id);
    }
    emit(state.copyWith(
      contactsCache: contactMapSnapShot,
      addedOnContactId: latestAddedOnContactId.toSet(),
    ));
  }

  void _onLogOutContactManager(
    LogOutContactManager event,
    Emitter<ContactManagerState> emit,
  ) async {
    emit(const ContactManagerState.initial());
  }

  void _onEditGroupData(
    EditGroupData event,
    Emitter<ContactManagerState> emit,
  ) async {
    globalBloc.add(ToProfileEdit(state.detailedContact!.id));
  }

  void _onUpdateContactProfile(
    UpdateContactProfile event,
    Emitter<ContactManagerState> emit,
  ) async {
    final contactCacheSnapshot = {...state.contactsCache};
    final avatarBase64MapSnapshot = {...state.avatarBase64Map};
    contactCacheSnapshot[event.contact.id] = event.contact;
    if (event.newAvatarId != '') {
      avatarBase64MapSnapshot[event.contact.id] = event.avatarBase64;
    }
    emit(state.copyWith(
      contactsCache: contactCacheSnapshot,
      avatarBase64Map: avatarBase64MapSnapshot,
    ));
  }

  void _onFetchGroupMembers(
    FetchGroupMembers event,
    Emitter<ContactManagerState> emit,
  ) async {
    final response = await groupApi.member(MemberData(id: event.groupId));
    final memberIdSet = response.data.member.toSet();
    final ownerId = response.data.owner;
    final groupMemberCacheSnapshot = {...state.groupMemberCache};
    final myGroupIdSetSnapshot = {...state.myGroupIdSet};
    final oldMembers = groupMemberCacheSnapshot[event.groupId];

    // 成员发生变化，则更新
    if (!setEquals(oldMembers, memberIdSet)) {
      if (ownerId == globalBloc.state.user.id) {
        myGroupIdSetSnapshot.add(event.groupId);
      }
      sqliteManager.saveMembers(event.groupId, ownerId, memberIdSet);
      groupMemberCacheSnapshot[event.groupId] = memberIdSet;
      emit(
        state.copyWith(
          groupMemberCache: groupMemberCacheSnapshot,
          myGroupIdSet: myGroupIdSetSnapshot,
        ),
      );
    }
  }
}
