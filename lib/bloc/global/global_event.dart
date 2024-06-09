import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/global/global_state.dart';

sealed class GlobalEvent {
  const GlobalEvent();
}

final class CreateUserTriggered extends GlobalEvent {
  CreateUserTriggered({required this.phone, required this.password});

  final String password;
  final String phone;
}

final class LoginTriggered extends GlobalEvent {
  LoginTriggered({
    required this.phone,
    required this.password,
    required this.context,
    required this.autoLogin,
  });

  final String password;
  final String phone;
  final BuildContext context;
  final bool autoLogin;
}

final class SwitchNavigationDestination extends GlobalEvent {
  const SwitchNavigationDestination({required this.destinationIndex});
  final int destinationIndex;
}

final class SwitchAppPage extends GlobalEvent {
  const SwitchAppPage({required this.currentPage});
  final AppPage currentPage;
}

final class BackToHome extends GlobalEvent {
  const BackToHome();
}

final class AutoLoginSucceed extends GlobalEvent {
  const AutoLoginSucceed(
    this.phone,
    this.password,
    this.id,
    this.name,
    this.profile,
  );
  final String phone;
  final String password;
  final int id;
  final String name;
  final String profile;
}

final class LogOutGlobal extends GlobalEvent {
  const LogOutGlobal();
}

final class ToProfileEdit extends GlobalEvent {
  const ToProfileEdit(this.id);
  final int id;
}

final class SetUserInfoGlobalBloc extends GlobalEvent {
  const SetUserInfoGlobalBloc(
      {required this.name,
      required this.profile,
      required this.avatarBase64,
      required this.newAvatarId});
  final String name;
  final String profile;
  final String avatarBase64;
  final String newAvatarId;
}
