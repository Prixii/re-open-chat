import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/message/message_event.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:unicons/unicons.dart';

class AudioMessage extends StatelessWidget {
  const AudioMessage({super.key, required this.messageId});
  final int messageId;
  @override
  Widget build(BuildContext context) {
    readMessageBloc(context).add(GetVoice(messageId));
    return InkWell(
      onTap: () => {readMessageBloc(context).add(PlayVoice(messageId))},
      child: const Icon(UniconsLine.play_circle),
    );
  }
}
