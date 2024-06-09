import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/global/global_bloc.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/global/global_state.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:re_open_chat/view/chat_manager.dart';
import 'package:re_open_chat/view/contacts_manager.dart';
import 'package:re_open_chat/view/profile.dart';
import 'package:unicons/unicons.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  final List<Widget> widgetOptions = const <Widget>[
    ContactsManager(),
    ChatManager(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(
      buildWhen: (prev, state) =>
          prev.destinationIndex != state.destinationIndex,
      builder: (context, state) {
        return Scaffold(
          body: Center(child: widgetOptions[state.destinationIndex]),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (index) => {
              readGlobalBloc(context)
                  .add(SwitchNavigationDestination(destinationIndex: index)),
            },
            selectedIndex: state.destinationIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(UniconsLine.users_alt),
                label: 'Contacts',
              ),
              NavigationDestination(
                icon: Icon(UniconsLine.comment),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: Icon(UniconsLine.setting),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
