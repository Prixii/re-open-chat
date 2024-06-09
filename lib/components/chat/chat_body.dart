import 'package:flutter/material.dart';
import 'package:re_open_chat/components/chat/message_list.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        // TODO 上下跳转按钮
        MessageList(),
      ],
    );
  }
}
