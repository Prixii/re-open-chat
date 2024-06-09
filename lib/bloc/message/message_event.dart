import 'package:re_open_chat/model/message.dart';

sealed class MessageEvent {
  const MessageEvent();
}

final class UpdateMessage extends MessageEvent {
  const UpdateMessage(
    this.unreadMessageCountMap,
    this.lastMessageMap,
    this.newMessageMap,
  );
  final Map<int, int> unreadMessageCountMap;
  final Map<int, Message?> lastMessageMap;

  ///
  /// [[contactId], [messageList]]
  ///
  final Map<int, List<Message>> newMessageMap;
}

final class UpdateAudio extends MessageEvent {
  const UpdateAudio(this.audioBase64, this.messageId);
  final String audioBase64;
  final int messageId;
}

final class UpdateImage extends MessageEvent {
  const UpdateImage(this.imageBase64, this.imageId);
  final String imageBase64;
  final String imageId;
}

final class InitializeMessageBloc extends MessageEvent {
  const InitializeMessageBloc();
}

final class LogOutMessage extends MessageEvent {
  const LogOutMessage();
}

final class LoadContactMessage extends MessageEvent {
  const LoadContactMessage(this.contactId);
  final int contactId;
}

final class SendOneMessage extends MessageEvent {
  const SendOneMessage(this.message);
  final Message message;
}

final class MessageListInitialize extends MessageEvent {
  const MessageListInitialize(this.scrollToBottom, this.scrollToTop);
  final void Function() scrollToBottom;
  final void Function() scrollToTop;
}

final class MessageListDispose extends MessageEvent {
  const MessageListDispose();
}

final class LoadImages extends MessageEvent {
  const LoadImages(this.imageIds, this.messageId);

  final List<String> imageIds;
  final int messageId;
}

final class GetVoice extends MessageEvent {
  const GetVoice(this.messageId);
  final int messageId;
}

final class PlayVoice extends MessageEvent {
  const PlayVoice(this.messageId);
  final int messageId;
}
