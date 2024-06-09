import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_open_chat/model/contact.dart';

part 'global_state.freezed.dart';

@freezed
class GlobalState with _$GlobalState {
  const factory GlobalState.initial({
    @Default(User()) User user,
    @Default(false) bool sendingRequest,
    @Default(1) int destinationIndex,
    @Default(AppPage.hello) AppPage currentPage,
    @Default(0) int? contactIdEditing,
  }) = _Initial;

  const factory GlobalState.debug({
    @Default(User.debug()) User user,
    @Default(false) bool sendingRequest,
    @Default(1) int destinationIndex,
    @Default(AppPage.hello) AppPage currentPage,
    @Default(0) int? contactIdEditing,
  }) = _Debug;
}

enum AppPage {
  applicationManager,
  chat,
  chatManager,
  contactDetail,
  contactsManager,
  hello,
  profileEdit,
  profile,
}
