sealed class ProfileEditEvent {
  const ProfileEditEvent();
}

final class InitializeProfileEditBloc extends ProfileEditEvent {
  const InitializeProfileEditBloc();
}

final class SubmitUserProfileEdit extends ProfileEditEvent {
  const SubmitUserProfileEdit({
    required this.newName,
    required this.newProfile,
  });
  final String newName;
  final String newProfile;
}

final class SubmitGroupProfileEdit extends ProfileEditEvent {
  const SubmitGroupProfileEdit({
    required this.newName,
    required this.newProfile,
  });
  final String newName;
  final String newProfile;
}

final class ChangeAvatar extends ProfileEditEvent {
  const ChangeAvatar(this.newAvatarBase64);
  final String newAvatarBase64;
}
