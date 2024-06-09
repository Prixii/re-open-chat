import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/message_box/message_box_bloc.dart';
import 'package:re_open_chat/bloc/message_box/message_box_event.dart';
import 'package:re_open_chat/components/chat/message_box/message_box.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:re_open_chat/view/splash.dart';
import 'package:unicons/unicons.dart';

const double maxRecordButtonSize = 100;
const double minRecordButtonSize = 40;
const preferredRecordButtonPadding =
    messageBoxHeight - messageBoxBottomPadding - messageBoxTopPadding;
final double preferredCancelRecordAreaDistance = -(screenSize.width * 0.7);

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with TickerProviderStateMixin {
  var isRecording = false;
  @override
  Widget build(BuildContext context) {
    final colorScheme = readThemeData(context).colorScheme;
    return BlocBuilder<MessageBoxBloc, MessageBoxState>(
      builder: (context, state) {
        var backgroundColor = readMessageBoxBloc(context).state.isRecording
            ? colorScheme.primary
            : colorScheme.primaryContainer;
        var iconColor = readMessageBoxBloc(context).state.isRecording
            ? Colors.white
            : colorScheme.onPrimaryContainer;
        return BlocListener<MessageBoxBloc, MessageBoxState>(
          listener: (context, state) {
            isRecording = state.isRecording;
          },
          listenWhen: (previous, current) =>
              previous.isRecording != current.isRecording,
          child: GestureDetector(
            onLongPressStart: (details) {
              readMessageBoxBloc(context).add(
                StartRecord(generateRecordFileName()),
              );
              tryVibrate();
            },
            onLongPressEnd: (details) {
              if (state.readyToCancel) {
                readMessageBoxBloc(context).add(const CancelRecord());
              } else {
                readMessageBoxBloc(context).add(const StopRecordAndSend());
              }
            },
            onLongPressMoveUpdate: (details) {
              if (details.offsetFromOrigin.dx <
                  preferredCancelRecordAreaDistance) {
                if (state.readyToCancel == false) {
                  readMessageBoxBloc(context).add(const EnterCancelArea());
                }
              } else {
                if (state.readyToCancel == true) {
                  readMessageBoxBloc(context).add(const LeaveCancelArea());
                }
              }
            },
            child: AnimatedContainer(
              curve: Curves.elasticOut,
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
              ),
              width: isRecording ? maxRecordButtonSize : minRecordButtonSize,
              height: isRecording ? maxRecordButtonSize : minRecordButtonSize,
              child: Center(
                child: Icon(
                  UniconsLine.record_audio,
                  color: iconColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

String generateRecordFileName() {
  var now = DateTime.now();
  return '/${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-${now.second}.mp3';
}
