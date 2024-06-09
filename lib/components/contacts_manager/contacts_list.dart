import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_bloc.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_event.dart';
import 'package:re_open_chat/components/contacts_manager/contacts_list_tile.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    var addedOnContacts =
        readContactManagerBloc(context).state.addedOnContactId.toList();
    return BlocListener<ContactManagerBloc, ContactManagerState>(
      listener: (context, state) {
        addedOnContacts = state.addedOnContactId.toList();
      },
      listenWhen: (previous, current) =>
          previous.addedOnContactId != current.addedOnContactId,
      child: ListView.builder(
        itemCount: addedOnContacts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => {
              readContactManagerBloc(context)
                  .add(ToContactDetail(contactId: addedOnContacts[index]))
            },
            child: ContactListTile(
                contactId: addedOnContacts[index],
                key: Key(addedOnContacts[index].toString())),
          );
        },
      ),
    );
  }
}
