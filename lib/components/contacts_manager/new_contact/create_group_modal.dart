import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/create_group/create_group_bloc.dart';
import 'package:re_open_chat/bloc/create_group/create_group_event.dart';
import 'package:re_open_chat/components/contacts_manager/contacts_list_tile.dart';
import 'package:re_open_chat/components/hello/tabbed_view.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class CreateGroupModal extends StatelessWidget {
  const CreateGroupModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextField(
          'Group Name',
          readCreateGroupBloc(context).groupNameController,
        ),
        BlocSelector<CreateGroupBloc, CreateGroupState, int>(
          selector: (state) {
            return state.initialMembers.length;
          },
          builder: (context, initialMemberCount) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$initialMemberCount Member Selected',
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.grey),
              ),
            );
          },
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 328),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: readCreateGroupBloc(context).state.contactsId.length,
            itemBuilder: ((context, index) {
              final contactId =
                  readCreateGroupBloc(context).state.contactsId[index];
              if (Contact.isGroup(contactId)) {
                return const SizedBox.shrink();
              }
              return Row(
                key: Key(contactId.toString()),
                children: [
                  BlocSelector<CreateGroupBloc, CreateGroupState, bool>(
                    selector: (state) {
                      return state.initialMembers.contains(contactId);
                    },
                    builder: (context, checked) {
                      var checkBoxValue = checked;

                      return Checkbox(
                        value: checkBoxValue,
                        onChanged: (value) {
                          if (value == null) return;
                          value
                              ? readCreateGroupBloc(context)
                                  .add(AddContact(contactId))
                              : readCreateGroupBloc(context)
                                  .add(RemoveContact(contactId));
                        },
                      );
                    },
                  ),
                  Expanded(child: ContactListTile(contactId: contactId)),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
