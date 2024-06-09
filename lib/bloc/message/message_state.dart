part of 'message_bloc.dart';

@freezed
class MessageState with _$MessageState {
  const factory MessageState.initial({
    @Default({}) Map<int, Message?> lastMessage,
    @Default({}) Map<int, int> unreadMessageCount,
    @Default([]) List<Message> currentChatMessages,
    @Default({}) Map<String, String> imageBase64Map,
    @Default({}) Map<int, String> voiceBase64Map,
  }) = _Initial;
}
