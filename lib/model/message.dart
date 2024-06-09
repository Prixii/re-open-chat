import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:re_open_chat/network/message/types.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  const factory Message({
    @Default(0) int id,
    @Default(0) int senderId,
    @Default(0) int contactId,
    @Default('') String content,
    @Default(0) int time,
    @Default([]) List<String> imgs,
    @Default([]) List<XFile> imgFiles,
    @Default(false) bool isVoice,
  }) = _Message;

  factory Message.fromMessageData(MessageData data, int contactId) {
    return Message(
      id: data.id,
      senderId: data.sender,
      contactId: contactId,
      content: data.content,
      time: data.time,
      imgs: data.img,
      isVoice: data.isVoice,
    );
  }
}

enum MessageType {
  text,
  textWithImg,
  voice,
}

extension MessageTypeExtension on Message {
  MessageType getType() {
    if (isVoice) {
      return MessageType.voice;
    } else if (imgs.isNotEmpty) {
      return MessageType.textWithImg;
    } else {
      return MessageType.text;
    }
  }
}
