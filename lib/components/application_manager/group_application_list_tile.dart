import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/application/application_event.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_bloc.dart';
import 'package:re_open_chat/components/universal/rounded_image.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/network/group/types.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:unicons/unicons.dart';

class GroupApplicationListTile extends StatelessWidget {
  const GroupApplicationListTile({super.key, required this.groupApplication});

  final RequestResponseContent groupApplication;

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
    contactManagerBloc.getContactById(groupApplication.id);
    return BlocSelector<ContactManagerBloc, ContactManagerState,
        (User?, Group?)>(
      selector: (state) {
        return (
          state.contactsCache[groupApplication.id] as User?,
          state.contactsCache[groupApplication.id] as Group?
        );
      },
      builder: (context, contactInfo) {
        var (user, group) = contactInfo;
        if (user == null || group == null) return Container();
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
                      _buildInfo(user, group),
                      Expanded(child: Container()),
                      IconButton(
                        onPressed: () => {
                          readApplicationBloc(context)
                              .add(RejectGroupApplication(
                            groupId: groupApplication.groupID,
                            contactId: groupApplication.id,
                          ))
                        },
                        icon: Icon(
                          UniconsLine.multiply,
                          color: readThemeData(context).colorScheme.error,
                        ),
                      ),
                      IconButton(
                        onPressed: () => {
                          readApplicationBloc(context)
                              .add(AcceptGroupApplication(
                            groupId: groupApplication.groupID,
                            contactId: groupApplication.id,
                          ))
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
      contactId: groupApplication.id,
    );
  }

  Widget _buildInfo(User user, Group group) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${user.name}申请加入${group.name}',
              style: nameStyle,
            ),
            Text(
              user.profile,
              style: profileStyle,
            ),
          ],
        ),
      ),
    );
  }
}
