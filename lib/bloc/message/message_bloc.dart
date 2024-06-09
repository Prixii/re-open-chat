import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_open_chat/bloc/message/message_event.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/manager/sqlite_manager.dart';
import 'package:re_open_chat/model/message.dart';
import 'package:re_open_chat/utils/audio_utils.dart';
import 'package:re_open_chat/utils/image_utils.dart';
import 'package:re_open_chat/utils/sqlite/message.dart';

part 'message_state.dart';
part 'message_bloc.freezed.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(const MessageState.initial()) {
    on<UpdateMessage>(_onUpdateMessage);
    on<UpdateAudio>(_onUpdateAudio);
    on<UpdateImage>(_onUpdateImage);
    on<InitializeMessageBloc>(_onInitialize);
    on<LogOutMessage>(_onLogOutMessage);
    on<LoadContactMessage>(_onLoadContactMessages);
    on<SendOneMessage>(_onSendOneMessage);
    on<MessageListInitialize>(_onMessageListInitialize);
    on<MessageListDispose>(_onMessageListDispose);
    on<LoadImages>(_onLoadImages);
    on<GetVoice>(_onGetVoice);
    on<PlayVoice>(_onPlayVoice);
  }

  void Function()? _scrollToBottom;
  // ignore: unused_field
  void Function()? _scrollToTop;
  void _onUpdateMessage(
    UpdateMessage event,
    Emitter<MessageState> emit,
  ) async {
    final currentChatId = chatManagerBloc.state.currentContact?.id;
    late List<Message> currentMessageList;

    if (currentChatId != null) {
      final othersMessage = [];
      final newMessageSnapshot = [...?event.newMessageMap[currentChatId]];
      final userId = globalBloc.state.user.id;
      for (var message in newMessageSnapshot) {
        if (message.senderId == userId) continue;
        othersMessage.add(message);
      }
      currentMessageList = [...state.currentChatMessages, ...othersMessage];
    } else {
      currentMessageList = [];
    }
    emit(state.copyWith(
      unreadMessageCount: event.unreadMessageCountMap,
      lastMessage: event.lastMessageMap,
      currentChatMessages: currentMessageList,
    ));
    _scrollToBottom?.call();
  }

  void _onUpdateAudio(
    UpdateAudio event,
    Emitter<MessageState> emit,
  ) async {
    final audioMap = {...state.voiceBase64Map};
    audioMap[event.messageId] = event.audioBase64;
    emit(state.copyWith(voiceBase64Map: audioMap));
  }

  void _onUpdateImage(
    UpdateImage event,
    Emitter<MessageState> emit,
  ) async {
    final imageMap = state.imageBase64Map;
    imageMap[event.imageId] = event.imageBase64;
    emit(state.copyWith(imageBase64Map: imageMap));
  }

  void _onInitialize(
    InitializeMessageBloc event,
    Emitter<MessageState> emit,
  ) async {
    final lastMessageMap = await sqliteManager.loadAllLastMessage();
    final unreadMessageCountMap =
        await sqliteManager.loadAllUnreadMessageCount();
    emit(state.copyWith(
      lastMessage: lastMessageMap,
      unreadMessageCount: unreadMessageCountMap,
    ));
  }

  void _onLogOutMessage(
    LogOutMessage event,
    Emitter<MessageState> emit,
  ) async {
    emit(const MessageState.initial());
  }

  void _onLoadContactMessages(
    LoadContactMessage event,
    Emitter<MessageState> emit,
  ) async {
    final messages = await sqliteManager.loadUnreadMessage(event.contactId);
    emit(state.copyWith(currentChatMessages: messages));
    _scrollToBottom?.call();
  }

  void _onSendOneMessage(
    SendOneMessage event,
    Emitter<MessageState> emit,
  ) async {
    final currentMessagesSnapshot = state.currentChatMessages;
    final currentChatId = chatManagerBloc.state.currentContact?.id;
    if (currentChatId == null) return;
    emit(state.copyWith(
      currentChatMessages: [...currentMessagesSnapshot, event.message],
    ));
    _scrollToBottom?.call();
  }

  void _onMessageListInitialize(
    MessageListInitialize event,
    Emitter<MessageState> emit,
  ) async {
    _scrollToBottom = event.scrollToBottom;
    _scrollToTop = event.scrollToTop;
    _scrollToBottom?.call();
  }

  void _onMessageListDispose(
    MessageListDispose event,
    Emitter<MessageState> emit,
  ) async {
    _scrollToBottom = null;
    _scrollToTop = null;
  }

  void _onLoadImages(
    LoadImages event,
    Emitter<MessageState> emit,
  ) async {
    final imageIds = event.imageIds;
    final imageBase64MapSnapshot = {...state.imageBase64Map};
    for (final imageId in imageIds) {
      var base64 = imageBase64MapSnapshot[imageId];
      if (base64 == null) {
        base64 = await getImageBase64ById(imageId, messageId: event.messageId);
        imageBase64MapSnapshot[imageId] = base64;
      }
    }
    emit(state.copyWith(imageBase64Map: imageBase64MapSnapshot));
  }

  void _onGetVoice(
    GetVoice event,
    Emitter<MessageState> emit,
  ) async {
    if (state.voiceBase64Map[event.messageId] != null) return;
    final voiceBase64Snapshot = {...state.voiceBase64Map};
    final voiceBase64 = await getAudioBase64ById(event.messageId);
    voiceBase64Snapshot[event.messageId] = voiceBase64;
    emit(state.copyWith(
        voiceBase64Map: {...state.voiceBase64Map, ...voiceBase64Snapshot}));
  }

  void _onPlayVoice(
    PlayVoice event,
    Emitter<MessageState> emit,
  ) async {
    final voiceBase64 = state.voiceBase64Map[event.messageId];
    if (voiceBase64 == null) return;
    playAudioFromBase64(voiceBase64, event.messageId);
  }
}
