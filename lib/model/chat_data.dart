import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/model/message.dart';

part 'chat_data.freezed.dart';

@freezed
class ChatData with _$ChatData {
  const factory ChatData({
    @Default(0) int unreadMessageCount,
    required User user,
    @Default(null) Message? lastMessage,
  }) = _ChatData;
}
