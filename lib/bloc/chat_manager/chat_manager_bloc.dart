import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_open_chat/bloc/chat_manager/chat_manager_event.dart';
import 'package:re_open_chat/bloc/message/message_event.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:re_open_chat/utils/client_utils.dart';

part 'chat_manager_state.dart';
part 'chat_manager_bloc.freezed.dart';

class ChatManagerBloc extends Bloc<ChatManagerEvent, ChatManagerState> {
  ChatManagerBloc() : super(const ChatManagerState.initial()) {
    on<ToChat>(_onToChat);
    on<ChatUpdate>(_onChatUpdate);
    on<InitializeChatManager>(_onInitialize);
    on<LogOutChatManager>(_onLogOutChatManager);
  }

  void _onToChat(ToChat event, Emitter<ChatManagerState> emit) {
    messageBloc.add(LoadContactMessage(event.contact.id));
    emit(
      state.copyWith(
        currentContact: event.contact,
      ),
    );
    router.goNamed('chat');
  }

  void _onChatUpdate(
    ChatUpdate event,
    Emitter<ChatManagerState> emit,
  ) async {
    talker.debug('chat update');
  }

  void _onInitialize(
    InitializeChatManager event,
    Emitter<ChatManagerState> emit,
  ) async {
    emit(state.copyWith(
        contacts: contactManagerBloc.state.contactsCache.values.toList()));
  }

  void _onLogOutChatManager(
    LogOutChatManager event,
    Emitter<ChatManagerState> emit,
  ) async {
    emit(const ChatManagerState.initial());
  }
}
