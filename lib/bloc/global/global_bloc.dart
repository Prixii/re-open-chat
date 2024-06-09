import 'package:go_router/go_router.dart';
import 'package:re_open_chat/bloc/chat_manager/chat_manager_event.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_event.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/global/global_state.dart';
import 'package:bloc/bloc.dart';
import 'package:re_open_chat/bloc/message/message_event.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/manager/polling_manager.dart';
import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/network/user/types.dart';
import 'package:re_open_chat/network/user/user.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:re_open_chat/utils/image_utils.dart';
import 'package:re_open_chat/utils/sqlite/contact.dart';
import 'package:re_open_chat/view/splash.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(const GlobalState.initial()) {
    on<CreateUserTriggered>(_onCreateUserTriggered);
    on<LoginTriggered>(_onLoginTriggered);
    on<AutoLoginSucceed>(_onAutoLoginSucceed);
    on<SwitchNavigationDestination>(_onSwitchNavigationDestination);
    on<SwitchAppPage>(_onSwitchAppPage);
    on<BackToHome>(_onBackToHome);
    on<LogOutGlobal>(_onLogOut);
    on<ToProfileEdit>(_onToProfileEdit);
    on<SetUserInfoGlobalBloc>(_onSetUserInfoGlobalBloc);
  }

  void _onCreateUserTriggered(
      CreateUserTriggered event, Emitter<GlobalState> emit) async {
    if (state.sendingRequest) return;
    emit(state.copyWith(sendingRequest: true));
    await userApi
        .createUser(CreateUserData(
          phoneNumber: event.phone,
          password: md5Encryption(event.password),
          deviceId: deviceId,
        ))
        .then((value) => {
              emit(state.copyWith(
                user: state.user.copyWith(
                  phone: event.phone,
                  id: value.data.id,
                  password: event.password,
                ),
                sendingRequest: false,
              ))
            })
        .whenComplete(() => emit(state.copyWith(sendingRequest: false)));
  }

  void _onLoginTriggered(
      LoginTriggered event, Emitter<GlobalState> emit) async {
    if (state.sendingRequest) return;
    emit(state.copyWith(sendingRequest: true));
    final md5Password = md5Encryption(event.password);
    await userApi
        .login(LoginData(
      phoneNumber: event.phone,
      password: md5Password,
      deviceId: deviceId,
    ))
        .then((value) async {
      emit(state.copyWith(
        user: state.user.copyWith(
          phone: event.phone,
          id: value.data.id,
          password: md5Password,
        ),
        sendingRequest: false,
      ));
      prefs.setString('phone', event.phone);
      prefs.setString('password', md5Password);
      prefs.setInt('id', value.data.id);
      prefs.setBool('autoLogin', event.autoLogin);
      await _onLoginSucceed().then((latestUserInfo) {
        emit(state.copyWith(user: latestUserInfo));
        event.context.go('/home');
      });
    }).whenComplete(() => emit(state.copyWith(sendingRequest: false)));
  }

  void _onAutoLoginSucceed(
      AutoLoginSucceed event, Emitter<GlobalState> emit) async {
    emit(state.copyWith(
      user: state.user.copyWith(
        id: event.id,
        name: event.name,
        profile: event.profile,
        phone: event.phone,
        password: event.password,
      ),
    ));
    await _onLoginSucceed().then((latestUserInfo) {
      emit(state.copyWith(user: latestUserInfo));
      router.go('/home');
    });
  }

  Future<User> _onLoginSucceed() async {
    late User latestUserInfo;
    detectVibration();
    await sqliteManager.initSqlite();
    await userApi
        .getInfo(GetInfoData(id: state.user.id))
        .then((response) async {
      final profile = response.data.profile;
      final avatarId = response.data.avatar;
      final name = response.data.name;
      latestUserInfo = state.user.copyWith(
        name: name,
        profile: profile,
        avatarId: avatarId,
      );
      await sqliteManager.updateContactInfo([latestUserInfo]);
    });
    contactManagerBloc.add(const InitializeContactManager());
    return latestUserInfo;
  }

  void _onSwitchNavigationDestination(
      SwitchNavigationDestination event, Emitter<GlobalState> emit) {
    emit(state.copyWith(destinationIndex: event.destinationIndex));
  }

  void _onSwitchAppPage(SwitchAppPage event, Emitter<GlobalState> emit) {
    emit(state.copyWith(currentPage: event.currentPage));
    switch (state.currentPage) {
      case AppPage.hello:
        return;
      case AppPage.applicationManager:
        pollingManager.stopAll();
        break;
      default:
        pollingManager.checkAll();
    }
  }

  void _onBackToHome(
    BackToHome event,
    Emitter<GlobalState> emit,
  ) {
    switch (state.destinationIndex) {
      case 0:
        emit(state.copyWith(currentPage: AppPage.contactsManager));
        break;
      case 1:
        emit(state.copyWith(currentPage: AppPage.chatManager));
        break;
      case 2:
        emit(state.copyWith(currentPage: AppPage.profile));
    }
    talker.debug('currentPage: ${state.currentPage}');
    pollingManager.checkAll();
  }

  void _onLogOut(
    LogOutGlobal event,
    Emitter<GlobalState> emit,
  ) async {
    pollingManager.stopAll();
    contactManagerBloc.add(const LogOutContactManager());
    chatManagerBloc.add(const LogOutChatManager());
    messageBloc.add(const LogOutMessage());
    clearSharedPreference();
    emit(state.copyWith(user: const User()));
    router.goNamed('hello');
  }

  void _onToProfileEdit(
    ToProfileEdit event,
    Emitter<GlobalState> emit,
  ) async {
    router.goNamed('profile-edit');

    emit(state.copyWith(
      currentPage: AppPage.profileEdit,
      contactIdEditing: event.id,
    ));
  }

  void _onSetUserInfoGlobalBloc(
    SetUserInfoGlobalBloc event,
    Emitter<GlobalState> emit,
  ) async {
    var newUser = state.user.copyWith(
      name: event.name,
      profile: event.profile,
    );
    final newAvatarId = event.newAvatarId;
    if (newAvatarId != '') {
      saveBase64ToImageFile(event.avatarBase64, newAvatarId, isAvatar: true);
      newUser = newUser.copyWith(avatarId: newAvatarId);
      contactManagerBloc.add(UpdateContactProfile(
        newUser,
        event.avatarBase64,
        newAvatarId,
      ));
    }
    emit(state.copyWith(
      user: newUser,
    ));
    await sqliteManager.updateContactInfo([newUser]);
  }
}
