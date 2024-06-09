import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:re_open_chat/bloc/message/message_event.dart';
import 'package:re_open_chat/bloc/message_box/message_box_event.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:re_open_chat/model/message.dart';
import 'package:re_open_chat/network/message/message.dart';
import 'package:re_open_chat/network/message/types.dart';
import 'package:re_open_chat/utils/audio_utils.dart';
import 'package:re_open_chat/utils/client_utils.dart';
import 'package:re_open_chat/utils/image_utils.dart';
import 'package:re_open_chat/utils/sqlite/message.dart';

part 'message_box_state.dart';
part 'message_box_bloc.freezed.dart';

class MessageBoxBloc extends Bloc<MessageBoxEvent, MessageBoxState> {
  MessageBoxBloc()
      : super(MessageBoxState.initial(
            messageController: TextEditingController())) {
    on<StartRecord>(_onStartRecord);
    on<CancelRecord>(_onCancelRecord);
    on<EnterCancelArea>(_onEnterCancelArea);
    on<LeaveCancelArea>(_onLeaveCancelArea);
    on<StopRecordAndSend>(_onStopRecordAndSend);
    on<SendMessage>(_onSendMessage);
    on<AddImages>(_onAddImage);
    on<RemoveImage>(_onRemoveImage);
    on<UpdateText>(_onUpdateText);
    on<MessageBoxInitialize>(_onMessageBoxInitialize);
  }

  void _onStartRecord(StartRecord event, emit) {
    if (state.isRecording) {
      throw Exception('already recording');
    }
    startRecord(event.recordPath);
    emit(state.copyWith(isRecording: true, readyToCancel: false));
  }

  void _onCancelRecord(CancelRecord _, emit) {
    talker.debug('Record canceled');
    if (!state.isRecording) {
      throw Exception('not recording');
    }
    cancelRecord();
    emit(state.copyWith(isRecording: false, readyToCancel: false));
  }

  void _onEnterCancelArea(
    EnterCancelArea event,
    Emitter<MessageBoxState> emit,
  ) async {
    if (state.isRecording) {
      tryVibrate();
      emit(state.copyWith(readyToCancel: true));
    }
  }

  void _onLeaveCancelArea(
    LeaveCancelArea event,
    Emitter<MessageBoxState> emit,
  ) async {
    if (state.isRecording) {
      emit(state.copyWith(readyToCancel: false));
    }
  }

  void _onStopRecordAndSend(StopRecordAndSend event, emit) async {
    if (!state.isRecording) {
      throw Exception('not recording');
    }
    final voiceBase64 = await stopRecord();
    emit(state.copyWith(isRecording: false, voiceBase64: voiceBase64));
    if (voiceBase64 == '') return;
    add(const SendMessage());
  }

  void _onSendMessage(SendMessage event, emit) async {
    final textSnapshot = state.text;
    final voiceSnapshot = state.voiceBase64;
    final imagesSnapshot = state.images;
    if (voiceSnapshot == '') {
      final imageIdList = <String>[];
      // 图文消息
      final Message message = Message(
        senderId: globalBloc.state.user.id,
        contactId: chatManagerBloc.state.currentContact!.id,
        content: textSnapshot,
        imgFiles: imagesSnapshot,
        isVoice: false,
      );

      for (var image in imagesSnapshot) {
        final base64 = await parseImageToBase64(image);
        await messageApi
            .upload(UploadData(type: 'img', content: base64))
            .then((response) {
          final imageId = response.data.id;
          imageIdList.add(imageId);
          saveBase64ToImageFile(base64, imageId);
          talker.debug('upload image: $imageId');
        });
      }
      await messageApi
          .send(SendData(
              id: message.contactId,
              content: message.content,
              img: imageIdList,
              voice: ''))
          .then((response) {
        final messageWithId = message.copyWith(
          id: response.data.id,
          imgs: imageIdList,
          isVoice: false,
        );
        sqliteManager.insertMessages(
          [messageWithId],
          message.contactId,
        );
        messageBloc.add(SendOneMessage(message));
      });
      state.messageController?.text = '';
      emit(state.copyWith(
        text: '',
        voiceBase64: '',
        images: [],
      ));
    } else {
      // 语音消息
      final contactId = chatManagerBloc.state.currentContact!.id;
      await messageApi
          .send(SendData(
        voice: voiceSnapshot,
        id: contactId,
        content: '',
        img: [],
      ))
          .then(
        (response) {
          final voiceId = response.data.id;
          final messageWithId = Message(
            id: voiceId,
            isVoice: true,
            content: voiceSnapshot,
            senderId: globalBloc.state.user.id,
          );
          sqliteManager.insertMessages(
            [messageWithId],
            contactId,
          );
          messageBloc.add(SendOneMessage(messageWithId));
          state.messageController?.text = '';
          emit(state.copyWith(
            text: '',
            voiceBase64: '',
            images: [],
          ));
        },
      );
    }
  }

  void _onAddImage(AddImages event, emit) async {
    final imageFiles = event.list;
    final newImgs = <XFile>[];
    final imageFilesSnapshot = state.images;
    for (var img in imageFiles) {
      if (containsImage(img, imageFilesSnapshot)) {
        talker.warning('duplicate image');
      } else {
        newImgs.add(img);
      }
    }
    final newImageList = [...imageFilesSnapshot, ...newImgs];
    emit(state.copyWith(images: newImageList));
  }

  void _onRemoveImage(RemoveImage event, emit) async {
    if (!state.images.contains(event.image)) {
      talker.warning('unselected image');
      return;
    }
    talker.debug('remove image');
    final newImageList = [...state.images]
      ..removeWhere((img) => img.name == event.image.name);
    emit(state.copyWith(images: newImageList));
  }

  void _onUpdateText(
    UpdateText event,
    Emitter<MessageBoxState> emit,
  ) async {
    emit(state.copyWith(text: event.text));
  }

  bool showRecordButton() {
    return state.text.isEmpty;
  }

  void _onMessageBoxInitialize(
    MessageBoxInitialize event,
    Emitter<MessageBoxState> emit,
  ) async {
    state.messageController?.addListener(() {
      add(UpdateText(state.messageController!.text));
    });
  }
}
