part of 'profile_edit_bloc.dart';

@freezed
class ProfileEditState with _$ProfileEditState {
  const factory ProfileEditState.initial({
    @Default('') String avatarBase64,
    @Default('') String name,
    @Default('') String profile,
    @Default(0) int id,
    @Default(false) bool initialized,
    @Default(false) bool avatarChanged,
  }) = _Initial;
}
