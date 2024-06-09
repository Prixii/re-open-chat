part of 'create_group_bloc.dart';

@freezed
class CreateGroupState with _$CreateGroupState {
  const factory CreateGroupState.initial({
    @Default('') String groupName,
    @Default({}) Set<int> initialMembers,
    @Default([]) List<int> contactsId,
  }) = _Initial;
}
