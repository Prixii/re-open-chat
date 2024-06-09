import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_event.dart';
import 'package:re_open_chat/bloc/message/message_event.dart';
import 'package:re_open_chat/components/chat/message_bubble/audio_message.dart';
import 'package:re_open_chat/components/chat/message_bubble/image_masonry.dart';
import 'package:re_open_chat/components/chat/message_bubble/message_bubble_tail.dart';
import 'package:re_open_chat/components/universal/rounded_image.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/model/message.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({required this.message, super.key});
  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = readThemeData(context);
    final bubbleColor = _getBubbleColor(theme);
    final maxBubbleWidth = MediaQuery.of(context).size.width - 128;
    if (message.imgs.isNotEmpty) {
      readMessageBloc(context).add(LoadImages(message.imgs, message.id));
    }
    final isGroupMessage = Contact.isGroup(message.contactId);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: _senderIsMe()
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBubble(
                    bubbleColor, maxBubbleWidth, isGroupMessage, context),
                const SizedBox(width: 10),
                RoundedImage(
                  size: 36,
                  contactId: message.senderId,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      readContactManagerBloc(context).add(
                        ToContactDetail(
                          contactId: message.senderId,
                          fromGroup: Contact.isGroup(message.contactId),
                        ),
                      );
                    },
                    child: RoundedImage(
                      size: 36,
                      contactId: message.senderId,
                    )),
                const SizedBox(width: 10),
                _buildBubble(
                    bubbleColor, maxBubbleWidth, isGroupMessage, context),
              ],
            ),
    );
  }

  Widget _buildBubble(Color bubbleColor, double maxBubbleWidth,
      bool isGroupMessage, BuildContext context) {
    if (_senderIsMe()) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: isGroupMessage,
            child: Text(readGlobalBloc(context).state.user.name),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBubbleBody(bubbleColor, maxBubbleWidth),
              _buildBubbleTail(bubbleColor),
            ],
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: isGroupMessage,
            child: Text(readContactManagerBloc(context)
                    .state
                    .contactsCache[message.senderId]
                    ?.name ??
                ''),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBubbleTail(bubbleColor),
              _buildBubbleBody(bubbleColor, maxBubbleWidth),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildBubbleTail(Color bubbleColor) {
    return CustomPaint(painter: BubbleTailShape(bubbleColor));
  }

  Widget _buildBubbleBody(Color bubbleColor, double maxBubbleWidth) {
    return Flexible(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: _getBorderRadius(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageMasonry(
              imageUrls: message.imgs,
              imageFiles: message.imgFiles,
            ),
            Visibility(
              visible: !message.isVoice,
              child: SelectableText(
                message.content,
                maxLines: null,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Visibility(
              visible: message.isVoice,
              child: AudioMessage(
                messageId: message.id,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final myBorderRadius = const BorderRadius.only(
      topLeft: Radius.circular(18),
      bottomLeft: Radius.circular(18),
      bottomRight: Radius.circular(18));
  final othersBorderRadius = const BorderRadius.only(
      bottomLeft: Radius.circular(18),
      bottomRight: Radius.circular(18),
      topRight: Radius.circular(18));

  Color _getBubbleColor(ThemeData theme) {
    return _senderIsMe()
        ? theme.colorScheme.secondaryContainer
        : theme.colorScheme.primaryContainer;
  }

  BorderRadius _getBorderRadius() {
    return _senderIsMe() ? myBorderRadius : othersBorderRadius;
  }

  bool _senderIsMe() {
    return message.senderId == globalBloc.state.user.id;
  }
}
