part of 'find_new_contact_bloc.dart';

@freezed
class FindNewContactState with _$FindNewContactState {
  const factory FindNewContactState.initial({
    @Default([]) List<Contact> results,
    @Default('') String target,
    @Default(false) bool applicationSent,
  }) = _Initial;
}
