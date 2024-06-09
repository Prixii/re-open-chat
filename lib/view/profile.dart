import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/global/global_bloc.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/global/global_state.dart';
import 'package:re_open_chat/components/universal/base_info_display.dart';
import 'package:re_open_chat/components/universal/icon_option.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/utils/context_reader.dart';
import 'package:unicons/unicons.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    readGlobalBloc(context)
        .add(const SwitchAppPage(currentPage: AppPage.profile));
    return BlocSelector<GlobalBloc, GlobalState, Contact>(
      selector: (state) {
        return state.user;
      },
      builder: (context, userInfo) {
        return BaseInfoDisplay(
          contact: userInfo,
          child: Column(
            children: [
              IconOption(
                icon: UniconsLine.file_edit_alt,
                text: 'Edit Profile',
                onTap: () =>
                    {readGlobalBloc(context).add(ToProfileEdit(userInfo.id))},
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              ),
              IconOption(
                icon: UniconsLine.info_circle,
                text: 'About',
                onTap: () => {},
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              ),
              Divider(
                indent: 12,
                endIndent: 12,
                color: readThemeData(context).dividerColor,
              ),
              IconOption(
                icon: UniconsLine.signout,
                text: 'Log Out',
                onTap: () =>
                    {readGlobalBloc(context).add(const LogOutGlobal())},
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                color: readThemeData(context).colorScheme.error,
              ),
            ],
          ),
        );
      },
    );
  }
}
