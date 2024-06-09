import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_event.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/profile_edit/profile_edit_event.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/network/contact/contact.dart';
import 'package:re_open_chat/network/contact/types.dart';
import 'package:re_open_chat/network/group/group.dart';
import 'package:re_open_chat/network/group/types.dart';
import 'package:re_open_chat/network/user/types.dart';
import 'package:re_open_chat/network/user/user.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:re_open_chat/utils/sqlite/contact.dart';

part 'profile_edit_state.dart';
part 'profile_edit_bloc.freezed.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  ProfileEditBloc() : super(const _Initial()) {
    on<InitializeProfileEditBloc>(_onInitializeProfileEditBloc);
    on<SubmitUserProfileEdit>(_onSubmitUserProfileEdit);
    on<ChangeAvatar>(_onChangeAvatar);
    on<SubmitGroupProfileEdit>(_onSubmitGroupProfileEdit);

    add(const InitializeProfileEditBloc());
  }

  void _onInitializeProfileEditBloc(
    InitializeProfileEditBloc event,
    Emitter<ProfileEditState> emit,
  ) async {
    final contactId = globalBloc.state.contactIdEditing;
    if (contactId == null) return;
    final contact = contactManagerBloc.state.contactsCache[contactId];
    if (contact == null) return;
    emit(state.copyWith(
      id: contactId,
      name: contact.name,
      profile: contact.profile,
      avatarBase64: contactManagerBloc.state.avatarBase64Map[contactId] ?? '',
      initialized: true,
    ));
  }

  void _onSubmitUserProfileEdit(
    SubmitUserProfileEdit event,
    Emitter<ProfileEditState> emit,
  ) async {
    var newAvatarId = '';
    if (state.avatarChanged) {
      await contactApi
          .setAvatar(SetAvatarData(
        id: state.id,
        file: state.avatarBase64,
      ))
          .then((value) {
        newAvatarId = value.data.id;
      });
    }
    await userApi
        .setInfo(SetUserInfoData(
      name: event.newName,
      profile: event.newProfile,
    ))
        .then((value) {
      router.pop();
      globalBloc.add(SetUserInfoGlobalBloc(
        name: event.newName,
        profile: event.newProfile,
        avatarBase64: state.avatarBase64,
        newAvatarId: newAvatarId,
      ));
    });
  }

  void _onSubmitGroupProfileEdit(
    SubmitGroupProfileEdit event,
    Emitter<ProfileEditState> emit,
  ) async {
    var newAvatarId = '';
    // 如果头像改了，就发送改头像请求
    if (state.avatarChanged) {
      await contactApi
          .setAvatar(SetAvatarData(
        id: state.id,
        file: state.avatarBase64,
      ))
          .then((value) {
        newAvatarId = value.data.id;
      });
    }
    // 设置 info
    await groupApi
        .setInfo(SetGroupInfoData(
      name: event.newName,
      profile: event.newProfile,
      id: state.id,
    ))
        .then((value) async {
      // 退出，通知修改
      var newGroup = Group(
        id: state.id,
        name: event.newName,
        profile: event.newProfile,
      );
      if (state.avatarChanged) {
        newGroup = newGroup.copyWith(avatarId: newAvatarId);
      }
      contactManagerBloc.add(
        UpdateContactProfile(
          newGroup,
          state.avatarBase64,
          newAvatarId,
        ),
      );
      await sqliteManager.updateContactInfo([newGroup]);
      router.pop();
    });
  }

  void _onChangeAvatar(
    ChangeAvatar event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(state.copyWith(
      avatarChanged: true,
      avatarBase64: event.newAvatarBase64,
    ));
  }
}
