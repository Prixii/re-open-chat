import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/message_box/message_box_bloc.dart';
import 'package:re_open_chat/components/chat/message_box/audio_box/audio_box_layer.dart';
import 'package:re_open_chat/components/chat/message_box/audio_box/record_button.dart';
import 'package:re_open_chat/components/chat/message_box/message_box.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class AudioBox extends StatelessWidget {
  const AudioBox({super.key, required this.preferredWidth});
  final double preferredWidth;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxHeight: maxRecordButtonSize * 2,
      minHeight: maxRecordButtonSize * 2,
      minWidth: preferredWidth,
      maxWidth: preferredWidth,
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BlocSelector<MessageBoxBloc, MessageBoxState, bool>(
            selector: (state) {
              return state.isRecording;
            },
            builder: (context, state) {
              return Visibility(
                visible: readMessageBoxBloc(context).state.isRecording,
                child: const AudioBoxLayer(),
              );
            },
          ),
          Positioned(
            right: _buttonPositionRight + 8,
            bottom: _buttonPositionBottom,
            child: SizedBox(
              height: maxRecordButtonSize * 2,
              width: maxRecordButtonSize * 2,
              child: Center(
                child: BlocSelector<MessageBoxBloc, MessageBoxState, bool>(
                  selector: (state) {
                    return state.text.isEmpty && state.images.isEmpty;
                  },
                  builder: (context, textIsEmpty) {
                    return Visibility(
                      visible: textIsEmpty,
                      child: const RecordButton(),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  double get _buttonPositionRight => -maxRecordButtonSize + minContentSize / 2;

  double get _buttonPositionBottom {
    return -maxRecordButtonSize + messageBoxBottomPadding + minContentSize / 2;
  }
}
