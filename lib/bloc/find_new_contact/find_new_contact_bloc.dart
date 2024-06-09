import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_open_chat/bloc/find_new_contact/find_new_contact_event.dart';
import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/network/contact/contact.dart';
import 'package:re_open_chat/network/contact/types.dart';
import 'package:re_open_chat/network/user/types.dart';
import 'package:re_open_chat/network/user/user.dart';
import 'package:re_open_chat/utils/sqlite/contact.dart';

part 'find_new_contact_state.dart';
part 'find_new_contact_bloc.freezed.dart';

class FindNewContactBloc
    extends Bloc<FindNewContactEvent, FindNewContactState> {
  FindNewContactBloc() : super(const FindNewContactState.initial()) {
    on<FindNewContact>(_onFindNewContact);
    on<CreateApplication>(_onCreateApplication);
  }

  void _onFindNewContact(
    FindNewContact event,
    Emitter<FindNewContactState> emit,
  ) async {
    if (event.id == '') return;
    var id = int.parse(event.id);
    final result = await userApi.getInfo(GetInfoData(id: id));
    late final Contact newContact;
    if (Contact.isGroup(id)) {
      newContact = Group(
          avatarId: result.data.avatar,
          id: id,
          name: result.data.name,
          profile: result.data.profile);
    } else {
      newContact = User(
          avatarId: result.data.avatar,
          id: id,
          name: result.data.name,
          profile: result.data.profile);
    }
    final List<Contact> resultList = [newContact];
    await sqliteManager.updateContactInfo(resultList);
    emit(state.copyWith(results: resultList, applicationSent: false));
  }

  void _onCreateApplication(
    CreateApplication event,
    Emitter<FindNewContactState> emit,
  ) async {
    await contactApi.join(JoinData(id: event.id)).then((value) {
      assert(value.statusCode == 200);
      emit(state.copyWith(applicationSent: true));
    });
  }
}
