part of 'chat_manager_bloc.dart';

@freezed
class ChatManagerState with _$ChatManagerState {
  const factory ChatManagerState.initial({
    @Default(null) Contact? currentContact,
    @Default([]) List<Contact> contacts,
    @Default(false) bool haveChatExpanded,
    @Default(0) int expandedChatId,
  }) = _Initial;
}
