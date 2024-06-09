import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/chat_manager/chat_manager_event.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/global/global_state.dart';
import 'package:re_open_chat/components/universal/base_info_display.dart';
import 'package:re_open_chat/components/universal/line_button.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/network/contact/contact.dart';
import 'package:re_open_chat/network/contact/types.dart';
import 'package:re_open_chat/network/group/group.dart';
import 'package:re_open_chat/network/group/types.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class ContactDetail extends StatefulWidget {
  const ContactDetail({super.key});

  @override
  State<ContactDetail> createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  @override
  void initState() {
    super.initState();
    readGlobalBloc(context)
        .add(const SwitchAppPage(currentPage: AppPage.contactDetail));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        readGlobalBloc(context).add(const BackToHome());
        router.pop();
      },
      child: const ContactDetailBody(),
    );
  }
}

class ContactDetailBody extends StatelessWidget {
  const ContactDetailBody({super.key});

  bool hasAddedOn(BuildContext context, int contactId) {
    return readContactManagerBloc(context)
        .state
        .addedOnContactId
        .contains(contactId);
  }

  bool fromGroup(BuildContext context) {
    return readContactManagerBloc(context).state.groupId != null;
  }

  SizedBox _buildBottomSheet(BuildContext context, Contact contact) {
    return hasAddedOn(context, contact.id)
        ? SizedBox(
            height: 60,
            child: LineButton(
              onPressed: () =>
                  {readChatManagerBloc(context).add(ToChat(contact: contact))},
              text: 'Message',
            ),
          )
        : const SizedBox.shrink();
  }

  List<Widget> _buildGroupOptions(int contactId, BuildContext context,
      double bottomPadding, bool isMyGroup, bool isGroup, int? groupId) {
    return [
      _buildAminSetter(contactId, context, bottomPadding),
      _buildAddOnButton(contactId, context, bottomPadding, isMyGroup, isGroup),
      _buildToGroupProfileEditButton(
          contactId, context, bottomPadding, isMyGroup, isGroup),
      _buildRemoveButton(contactId, context, bottomPadding, isMyGroup, isGroup),
      _buildRemoveFromGroupButton(
          contactId, context, bottomPadding, isMyGroup, isGroup, groupId),
      _buildDismissGroup(contactId, context, bottomPadding, isMyGroup),
    ];
  }

  Widget _buildAminSetter(
      int contactId, BuildContext context, double bottomPadding) {
    // return readContactManagerBloc(context).state.isFromGroup
    //     ?
    //     AdministratorSetter(
    //         bottomPadding: bottomPadding,
    //       )
    //     : const SizedBox.shrink();
    return const SizedBox.shrink();
  }

  Widget _buildAddOnButton(
    int contactId,
    BuildContext context,
    double bottomPadding,
    bool isMyGroup,
    bool isGroup,
  ) {
    if ((isGroup && isMyGroup) || hasAddedOn(context, contactId)) {
      return const SizedBox.shrink();
    }
    return LineButton(
      onPressed: () => {
        contactApi.join(JoinData(id: contactId)).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('我踢死你!'),
              action: SnackBarAction(
                label: 'Action',
                onPressed: () {
                  // Code to execute.
                },
              ),
            ),
          );
        })
      },
      text: 'Add to Contacts',
      bottomPadding: bottomPadding,
    );
  }

  Widget _buildToGroupProfileEditButton(
    int contactId,
    BuildContext context,
    double bottomPadding,
    bool isMyGroup,
    bool isGroup,
  ) {
    if (isGroup && isMyGroup && Contact.isGroup(contactId)) {
      return LineButton(
        onPressed: () => {
          readGlobalBloc(context).add(
            ToProfileEdit(contactId),
          ),
        },
        text: 'Edit Group Profile',
        bottomPadding: bottomPadding,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildRemoveFromGroupButton(
    int contactId,
    BuildContext context,
    double bottomPadding,
    bool isMyGroup,
    bool isGroup,
    int? groupId,
  ) {
    if (isGroup && isMyGroup) {
      return LineButton(
        onPressed: () => {
          groupApi.t(TData(userID: contactId, groupID: groupId!)).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('鬼！!'),
                action: SnackBarAction(
                  label: 'Action',
                  onPressed: () {
                    // Code to execute.
                  },
                ),
              ),
            );
          })
        },
        text: 'Remove from Group',
        bottomPadding: bottomPadding,
        textColor: readThemeData(context).colorScheme.error,
        backgroundColor: readThemeData(context).colorScheme.errorContainer,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRemoveButton(int contactId, BuildContext context,
      double bottomPadding, bool isMyGroup, bool isGroup) {
    if ((isGroup || !hasAddedOn(context, contactId)) || isMyGroup) {
      return const SizedBox.shrink();
    }
    return LineButton(
      onPressed: () => {
        contactApi.exit(ExitData(id: contactId)).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('润了！!'),
              action: SnackBarAction(
                label: 'Action',
                onPressed: () {
                  // Code to execute.
                },
              ),
            ),
          );
        })
      },
      text: 'Remove from Contacts',
      bottomPadding: bottomPadding,
      textColor: readThemeData(context).colorScheme.error,
      backgroundColor: readThemeData(context).colorScheme.errorContainer,
    );
  }

  Widget _buildDismissGroup(int contactId, BuildContext context,
      double bottomPadding, bool isMyGroup) {
    if (Contact.isGroup(contactId) && isMyGroup) {
      return LineButton(
        onPressed: () {
          router.pop();
          contactApi.exit(ExitData(id: contactId));
        },
        text: 'Dismiss Group',
        bottomPadding: bottomPadding,
        textColor: readThemeData(context).colorScheme.error,
        backgroundColor: readThemeData(context).colorScheme.errorContainer,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final contactManagerBloc = readContactManagerBloc(context);
    final contact = contactManagerBloc.state.detailedContact;
    if (contact == null) {
      router.goNamed('home');
      throw Exception('Contact must not be null');
    }
    final groupId = readContactManagerBloc(context).state.groupId;
    final myGroupIds = readContactManagerBloc(context).state.myGroupIdSet;
    final isMyGroup =
        (myGroupIds.contains(groupId) || myGroupIds.contains(contact.id));
    final isGroup = groupId != null;
    const double buttonBottomPadding = 10;
    return Scaffold(
      body: BaseInfoDisplay(
        contact: contact,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: _buildGroupOptions(contact.id, context,
                buttonBottomPadding, isMyGroup, isGroup, groupId),
          ),
        ),
      ),
      bottomSheet: _buildBottomSheet(context, contact),
    );
  }
}
