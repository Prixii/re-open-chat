import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/global/global_state.dart';
import 'package:re_open_chat/components/contacts_manager/new_contact/add_contact_menu.dart';
import 'package:re_open_chat/components/contacts_manager/contacts_list.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:unicons/unicons.dart';

class ContactsManager extends StatelessWidget {
  const ContactsManager({super.key});

  @override
  Widget build(BuildContext context) {
    readGlobalBloc(context)
        .add(const SwitchAppPage(currentPage: AppPage.contactsManager));
    final theme = readThemeData(context);
    return Scaffold(
      appBar: _buildAppBar(theme),
      body: const ContactList(),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      shadowColor: theme.colorScheme.shadow,
      title: const Text('Contacts'),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: InkWell(
          onTap: () => {router.goNamed('application-manager')},
          child: Icon(
            UniconsLine.user_check,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.primaryContainer,
      actions: const [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AddContactMenu(),
          ],
        ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }
}
