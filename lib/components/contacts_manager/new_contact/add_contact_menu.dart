import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/create_group/create_group_bloc.dart';
import 'package:re_open_chat/bloc/create_group/create_group_event.dart';
import 'package:re_open_chat/bloc/find_new_contact/find_new_contact_bloc.dart';
import 'package:re_open_chat/components/contacts_manager/new_contact/create_group_modal.dart';
import 'package:re_open_chat/components/contacts_manager/new_contact/find_new_contact_modal.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:unicons/unicons.dart';

enum AddContactMenuEntry {
  findContact('Find Contact'),
  createGroup('Create Group');

  const AddContactMenuEntry(this.title);
  final String title;
}

class AddContactMenu extends StatelessWidget {
  const AddContactMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = readThemeData(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MenuAnchor(
          menuChildren: [
            MenuItemButton(
              leadingIcon: const Icon(UniconsLine.user_plus),
              child: Text(AddContactMenuEntry.findContact.title),
              onPressed: () => {
                Navigator.of(context)
                    .restorablePush(_findNewContactDialogBuilder)
              },
            ),
            MenuItemButton(
              leadingIcon: const Icon(UniconsLine.comments_alt),
              child: Text(AddContactMenuEntry.createGroup.title),
              onPressed: () => {
                Navigator.of(context).restorablePush(_createGroupDialogBuilder)
              },
            ),
          ],
          builder: (context, controller, child) => IconButton(
            icon: Icon(
              UniconsLine.plus,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => {
              if (!controller.isOpen)
                {controller.open()}
              else
                {controller.close()}
            },
          ),
        ),
      ],
    );
  }

  static Route<Object?> _findNewContactDialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Find New Contact', style: TextStyle(fontSize: 16)),
          content: BlocProvider(
              create: (context) => FindNewContactBloc(),
              child: const FindNewContactModal()),
          contentPadding: const EdgeInsets.only(
            left: 24.0,
            top: 16,
            right: 24.0,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Route<Object?> _createGroupDialogBuilder(
      BuildContext context, Object? arguments) {
    final createGroupBloc = CreateGroupBloc(
        readContactManagerBloc(context).state.addedOnContactId.toList());
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => createGroupBloc,
          child: AlertDialog(
            title: const Text('Create Group', style: TextStyle(fontSize: 16)),
            content: const CreateGroupModal(),
            contentPadding: const EdgeInsets.only(
              left: 24.0,
              top: 16,
              right: 24.0,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Create'),
                onPressed: () {
                  createGroupBloc.add(CreateGroup(Navigator.of(context).pop));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
