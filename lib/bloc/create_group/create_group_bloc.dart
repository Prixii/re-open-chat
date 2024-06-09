import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:re_open_chat/bloc/create_group/create_group_event.dart';
import 'package:re_open_chat/network/group/group.dart';
import 'package:re_open_chat/network/group/types.dart';
import 'package:re_open_chat/utils/client_utils.dart';

part 'create_group_state.dart';
part 'create_group_bloc.freezed.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  CreateGroupBloc(List<int> contactsId)
      : super(CreateGroupState.initial(contactsId: contactsId)) {
    on<CreateGroup>(_onCreateGroup);
    on<AddContact>(_onAddMember);
    on<RemoveContact>(_onRemoveContact);
  }

  final groupNameController = TextEditingController();

  void _onCreateGroup(
    CreateGroup event,
    Emitter<CreateGroupState> emit,
  ) async {
    final groupName = groupNameController.text;
    talker.debug('$groupName, $state');
    await groupApi
        .createGroup(
      CreateData(
        name: groupName,
        users: state.initialMembers.toList(),
      ),
    )
        .then((response) {
      if (response.statusCode != 200) return;
      try {
        event.pop();
      } catch (e) {
        talker.error(e);
      }
    });
  }

  void _onAddMember(
    AddContact event,
    Emitter<CreateGroupState> emit,
  ) async {
    final newInitialMembers = {...state.initialMembers, event.id};
    emit(state.copyWith(
      initialMembers: newInitialMembers,
    ));
  }

  void _onRemoveContact(
    RemoveContact event,
    Emitter<CreateGroupState> emit,
  ) async {
    final newInitialMembers = {...state.initialMembers}..remove(event.id);
    emit(
      state.copyWith(
        initialMembers: newInitialMembers,
      ),
    );
  }
}
