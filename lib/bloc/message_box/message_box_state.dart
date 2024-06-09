part of 'message_box_bloc.dart';

@freezed
class MessageBoxState with _$MessageBoxState {
  const factory MessageBoxState.initial({
    @Default('') String text,
    @Default(false) bool haveMessageInput,
    @Default(false) bool isRecording,
    @Default(false) bool readyToCancel,
    @Default(0) int recordTime,
    @Default('') String voiceBase64,
    @Default([]) List<XFile> images,
    @Default(null) TextEditingController? messageController,
  }) = _Initial;
}
