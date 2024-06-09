import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_event.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/message/message_bloc.dart';
import 'package:re_open_chat/bloc/message_box/message_box_bloc.dart';
import 'package:re_open_chat/components/chat/message_box/audio_box/audio_box.dart';
import 'package:re_open_chat/components/chat/chat_body.dart';
import 'package:re_open_chat/components/chat/message_box/image_container/image_container.dart';
import 'package:re_open_chat/components/chat/message_box/message_box.dart';
import 'package:re_open_chat/components/universal/rounded_image.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          readGlobalBloc(context).add(const BackToHome());
          router.pop();
        },
        child: const ChatPageBody());
  }
}

class ChatPageBody extends StatelessWidget {
  const ChatPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final contact = readChatManagerBloc(context).state.currentContact;
    final theme = readThemeData(context);
    if (contact == null) {
      router.goNamed('home');
      throw Exception('contact is null');
    }
    return BlocProvider(
      create: (context) => MessageBoxBloc(),
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          return LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: _buildAppBar(theme, contact, context),
              body: Stack(
                children: [
                  const Column(
                    children: [
                      Expanded(child: ChatBody()),
                      MessageBox(),
                    ],
                  ),
                  Positioned(
                    bottom: messageBoxHeight,
                    child: ImageContainer(
                      preferredWidth: constraints.maxWidth,
                    ),
                  ),
                  AudioBox(preferredWidth: constraints.maxWidth)
                ],
              ),
            );
          });
        },
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme, Contact contact, BuildContext context) {
    return AppBar(
      shadowColor: theme.colorScheme.shadow,
      title: Text(contact.name),
      centerTitle: true,
      backgroundColor: theme.colorScheme.primaryContainer,
      actions: [
        Contact.isGroup(contact.id)
            ? GestureDetector(
                onTap: () => readContactManagerBloc(context)
                    .add(ToContactDetail(contactId: contact.id)),
                child: RoundedImage(
                  size: 36,
                  contactId: contact.id,
                ))
            : Container(),
        const SizedBox(
          width: 16,
        )
      ],
    );
  }
}
