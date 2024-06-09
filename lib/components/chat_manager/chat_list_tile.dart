import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/chat_manager/chat_manager_event.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_bloc.dart';
import 'package:re_open_chat/bloc/message/message_bloc.dart';
import 'package:re_open_chat/components/chat_manager/unread_message_count_badge.dart';
import 'package:re_open_chat/components/universal/rounded_image.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/model/message.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({super.key, required this.contactId});

  final int contactId;

  @override
  Widget build(BuildContext context) {
    readContactManagerBloc(context).getContactById(contactId);
    return BlocSelector<ContactManagerBloc, ContactManagerState, Contact?>(
        selector: (state) {
      return state.contactsCache[contactId];
    }, builder: (context, contact) {
      if (contact == null) {
        return const SizedBox.shrink();
      }
      return InkWell(
        onTap: () =>
            {readChatManagerBloc(context).add(ToChat(contact: contact))},
        child: SizedBox(
          height: 64,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildAvatar(contact),
                      _buildCenterInfo(contact),
                      _buildRightInfo(context),
                    ],
                  ),
                ),
              ),
              Divider(
                indent: 12,
                endIndent: 12,
                height: 0.5,
                color: readThemeData(context).dividerColor,
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAvatar(Contact contact) {
    return RoundedImage(
      size: 48,
      contactId: contact.id,
    );
  }

  Widget _buildCenterInfo(Contact contact) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: BlocSelector<MessageBloc, MessageState, Message?>(
                  selector: (state) {
                    return state.lastMessage[contactId];
                  },
                  builder: (context, lastMessage) {
                    return Text(
                      '${_showSender(lastMessage, context)}:${_showContent(lastMessage)}',
                      style: const TextStyle(color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _showSender(Message? lastMessage, BuildContext context) {
    if (lastMessage == null) return '';
    return readContactManagerBloc(context)
            .state
            .contactsCache[lastMessage.senderId]
            ?.name ??
        '';
  }

  String _showContent(Message? lastMessage) {
    if (lastMessage == null) return '';
    if (lastMessage.isVoice) return '[语音]';
    if (lastMessage.content != '') return lastMessage.content;
    if (lastMessage.imgs.isNotEmpty) return '[图片]';
    if (lastMessage.imgFiles.isNotEmpty) return '[图片]';
    return '';
  }

  Widget _buildRightInfo(BuildContext context) {
    return SizedBox(
        width: 64,
        child: Column(
          children: [
            Expanded(
              child: Center(
                  child: BlocSelector<MessageBloc, MessageState, Message?>(
                      selector: (state) {
                return state.lastMessage[contactId];
              }, builder: (context, lastMessage) {
                return Text(
                  formatTime(lastMessage?.time ?? 0),
                  style: const TextStyle(color: Colors.grey),
                );
              })),
            ),
            Expanded(
              child: Center(
                child: BlocSelector<MessageBloc, MessageState, int>(
                  selector: (state) {
                    return state.unreadMessageCount[contactId] ?? 0;
                  },
                  builder: (context, unreadMessageCount) {
                    return UnreadMessageCountBadge(count: unreadMessageCount);
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
