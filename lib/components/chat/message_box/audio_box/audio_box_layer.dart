import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/message_box/message_box_bloc.dart';
import 'package:re_open_chat/components/chat/message_box/message_box.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class AudioBoxLayer extends StatelessWidget {
  const AudioBoxLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: messageBoxHeight,
      width: double.infinity,
      color: readThemeData(context).colorScheme.primaryContainer,
      child: Center(
        child: BlocSelector<MessageBoxBloc, MessageBoxState, bool>(
          selector: (state) {
            return state.readyToCancel;
          },
          builder: (context, readyToCancel) {
            return Text(
                readyToCancel ? 'Release to Cancel' : 'Slide to Cancel <<<<<<');
          },
        ),
      ),
    );
  }
}
