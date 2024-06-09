import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/application/application_event.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_bloc.dart';
import 'package:re_open_chat/components/universal/rounded_image.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:unicons/unicons.dart';

class FriendApplicationListTile extends StatelessWidget {
  const FriendApplicationListTile({super.key, required this.contactId});

  final int contactId;

  final nameStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  final profileStyle = const TextStyle(
    fontSize: 12,
    color: Colors.black87,
  );
  final double avatarSize = 38;

  @override
  Widget build(BuildContext context) {
    contactManagerBloc.getContactById(contactId);
    return BlocSelector<ContactManagerBloc, ContactManagerState, Contact?>(
      selector: (state) {
        return state.contactsCache[contactId];
      },
      builder: (context, contact) {
        if (contact == null) return Container();
        return SizedBox(
          height: 52,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildAvatar(),
                      _buildInfo(contact),
                      Expanded(child: Container()),
                      IconButton(
                        onPressed: () => {
                          readApplicationBloc(context)
                              .add(RejectFriendApplication(contactId))
                        },
                        icon: Icon(
                          UniconsLine.multiply,
                          color: readThemeData(context).colorScheme.error,
                        ),
                      ),
                      IconButton(
                        onPressed: () => {
                          readApplicationBloc(context)
                              .add(AcceptFriendApplication(contactId))
                        },
                        icon: const Icon(
                          UniconsLine.check,
                          color: Colors.green,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                indent: 12,
                endIndent: 12,
                height: 0.5,
                color: readThemeData(context).dividerColor,
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    return RoundedImage(
      size: avatarSize,
      contactId: contactId,
    );
  }

  Widget _buildInfo(Contact contact) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              contact.name,
              style: nameStyle,
            ),
            Text(
              contact.profile,
              style: profileStyle,
            ),
          ],
        ),
      ),
    );
  }
}
