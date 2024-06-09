import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/message/message_bloc.dart';
import 'package:re_open_chat/bloc/message/message_event.dart';
import 'package:re_open_chat/components/chat/message_bubble/message_bubble.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/model/message.dart';
import 'package:re_open_chat/utils/client_utils.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    messageBloc.add(MessageListInitialize(scrollToBottom, scrollToTop));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    messageBloc.add(const MessageListDispose());
    super.dispose();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      try {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      } catch (_) {}
    });
  }

  void scrollToTop() {
    Future.delayed(const Duration(milliseconds: 100), () {
      talker.debug('scroll');
      try {
        _scrollController.animateTo(_scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MessageBloc, MessageState, List<Message>>(
      selector: (state) {
        return state.currentChatMessages;
      },
      builder: (context, messageList) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: messageList.length,
          itemBuilder: (context, index) {
            final message = messageList[index];
            return MessageBubble(message: message);
          },
        );
      },
    );
  }
}
