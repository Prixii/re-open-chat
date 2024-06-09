import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/message/message_bloc.dart';
import 'package:re_open_chat/components/chat_manager/chat_list_tile.dart';
import 'package:re_open_chat/model/message.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MessageBloc, MessageState, Map<int, Message?>>(
      selector: (state) {
        return state.lastMessage;
      },
      builder: (context, lastMessageMap) {
        return ListView.builder(
          itemCount: lastMessageMap.length,
          itemBuilder: (context, index) {
            final contactId = lastMessageMap.keys.toList()[index];
            return ChatListTile(
              contactId: contactId,
              key: Key(lastMessageMap.keys.toList()[index].toString()),
            );
          },
        );
      },
    );
  }
}
