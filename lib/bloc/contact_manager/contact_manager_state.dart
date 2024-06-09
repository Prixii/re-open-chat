part of 'contact_manager_bloc.dart';

@freezed
class ContactManagerState with _$ContactManagerState {
  const factory ContactManagerState.initial({
    Contact? detailedContact,
    @Default(null) int? groupId,
    @Default({}) Map<int, Contact> contactsCache,
    @Default({}) Map<int, String> avatarBase64Map,
    @Default({}) Set<int> addedOnContactId,
    @Default({}) Set<int> myGroupIdSet,
    @Default({}) Map<int, Set<int>> groupMemberCache,
  }) = _Initial;
}
