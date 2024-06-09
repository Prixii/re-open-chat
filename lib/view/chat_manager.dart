import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/global/global_state.dart';
import 'package:re_open_chat/components/chat_manager/chat_list.dart';
import 'package:re_open_chat/components/universal/rounded_image.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class ChatManager extends StatelessWidget {
  const ChatManager({super.key});
  @override
  Widget build(BuildContext context) {
    readGlobalBloc(context)
        .add(const SwitchAppPage(currentPage: AppPage.chatManager));
    final theme = readThemeData(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: theme.colorScheme.shadow,
        title: const Text('Chat Manager'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        actions: [
          RoundedImage(
            size: 36,
            contactId: readGlobalBloc(context).state.user.id,
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: const ChatList(),
    );
  }
}
