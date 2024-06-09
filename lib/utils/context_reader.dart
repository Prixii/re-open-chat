import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/application/application_bloc.dart';
import 'package:re_open_chat/bloc/chat_manager/chat_manager_bloc.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_bloc.dart';
import 'package:re_open_chat/bloc/create_group/create_group_bloc.dart';
import 'package:re_open_chat/bloc/find_new_contact/find_new_contact_bloc.dart';
import 'package:re_open_chat/bloc/global/global_bloc.dart';
import 'package:re_open_chat/bloc/message/message_bloc.dart';
import 'package:re_open_chat/bloc/message_box/message_box_bloc.dart';
import 'package:re_open_chat/bloc/profile_edit/profile_edit_bloc.dart';
import 'package:re_open_chat/bloc/search_list/search_list_bloc.dart';

ApplicationBloc readApplicationBloc(BuildContext context) =>
    context.read<ApplicationBloc>();
ChatManagerBloc readChatManagerBloc(BuildContext context) =>
    context.read<ChatManagerBloc>();
ContactManagerBloc readContactManagerBloc(BuildContext context) =>
    context.read<ContactManagerBloc>();
CreateGroupBloc readCreateGroupBloc(BuildContext context) =>
    context.read<CreateGroupBloc>();
FindNewContactBloc readFindNewContactBloc(BuildContext context) =>
    context.read<FindNewContactBloc>();
GlobalBloc readGlobalBloc(BuildContext context) => context.read<GlobalBloc>();
MessageBloc readMessageBloc(BuildContext context) =>
    context.read<MessageBloc>();
MessageBoxBloc readMessageBoxBloc(BuildContext context) =>
    context.read<MessageBoxBloc>();
ProfileEditBloc readProfileEditBloc(BuildContext context) =>
    context.read<ProfileEditBloc>();
SearchListBloc readSearchListBloc(BuildContext context) =>
    context.read<SearchListBloc>();
ThemeData readThemeData(BuildContext context) => Theme.of(context);
