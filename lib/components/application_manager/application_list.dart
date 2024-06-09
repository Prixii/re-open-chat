import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/application/application_bloc.dart';
import 'package:re_open_chat/components/application_manager/application_list_tile.dart';
import 'package:re_open_chat/components/application_manager/group_application_list_tile.dart';
import 'package:re_open_chat/network/group/types.dart';

class ApplicationList extends StatelessWidget {
  const ApplicationList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ApplicationBloc, ApplicationState,
        (List<int>, List<RequestResponseContent>)>(
      selector: (state) {
        return (state.applications, state.groupApplications);
      },
      builder: (context, applicationData) {
        var (applicationIdList, groupApplicationList) = applicationData;
        return ListView.builder(
            itemCount: applicationIdList.length + groupApplicationList.length,
            itemBuilder: (context, index) {
              if (index < applicationIdList.length) {
                return FriendApplicationListTile(
                  key: Key(applicationIdList[index].toString()),
                  contactId: applicationIdList[index],
                );
              } else {
                return GroupApplicationListTile(
                  key: Key(
                      groupApplicationList[index - applicationIdList.length]
                          .toString()),
                  groupApplication:
                      groupApplicationList[index - applicationIdList.length],
                );
              }
            });
      },
    );
  }
}
