import 'package:re_open_chat/model/contact.dart';

sealed class ChatManagerEvent {
  const ChatManagerEvent();
}

final class ToChat extends ChatManagerEvent {
  const ToChat({required this.contact});
  final Contact contact;
}

final class ChatUpdate extends ChatManagerEvent {
  const ChatUpdate();
}

final class InitializeChatManager extends ChatManagerEvent {
  const InitializeChatManager();
}

final class LogOutChatManager extends ChatManagerEvent {
  const LogOutChatManager();
}
