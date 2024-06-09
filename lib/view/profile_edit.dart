import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_open_chat/bloc/profile_edit/profile_edit_bloc.dart';
import 'package:re_open_chat/bloc/profile_edit/profile_edit_event.dart';
import 'package:re_open_chat/components/hello/tabbed_view.dart';
import 'package:re_open_chat/components/profile_edit/avatar_selector.dart';
import 'package:re_open_chat/model/contact.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileEditBloc(),
      child: const ProfileEditBody(),
    );
  }
}

class ProfileEditBody extends StatefulWidget {
  const ProfileEditBody({super.key});

  @override
  State<ProfileEditBody> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEditBody> {
  late Mode mode;
  late TextEditingController _nameController, _profileController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _profileController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Contact? contact =
        readContactManagerBloc(context).state.detailedContact;
    if (contact != null) {
      if (Contact.isGroup(contact.id)) mode = Mode.group;
    } else {
      mode = Mode.me;
    }
    final theme = readThemeData(context);
    return Scaffold(
      appBar: _buildAppBar(theme),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: BlocListener<ProfileEditBloc, ProfileEditState>(
          listener: (context, state) {
            final state = readProfileEditBloc(context).state;
            _nameController.text = state.name;
            _profileController.text = state.profile;
          },
          listenWhen: (previous, current) =>
              previous.initialized == false && current.initialized == true,
          child: Column(
            children: [
              const AvatarSelector(),
              buildTextField('Name', _nameController),
              const SizedBox(height: 32),
              buildTextField('Profile', _profileController, maxLines: 5)
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      shadowColor: theme.colorScheme.shadow,
      title: _buildTitle(),
      centerTitle: true,
      backgroundColor: theme.colorScheme.primaryContainer,
      leading: TextButton(
        onPressed: () => {router.pop()},
        child: const Text('Back'),
      ),
      actions: [
        TextButton(
          onPressed: () => {
            if (Contact.isGroup(readProfileEditBloc(context).state.id))
              {
                readProfileEditBloc(context).add(
                  SubmitGroupProfileEdit(
                    newName: _nameController.text,
                    newProfile: _profileController.text,
                  ),
                )
              }
            else
              {
                readProfileEditBloc(context).add(
                  SubmitUserProfileEdit(
                    newName: _nameController.text,
                    newProfile: _profileController.text,
                  ),
                )
              }
          },
          child: const Text('Accept'),
        ),
      ],
    );
  }

  Text _buildTitle() {
    return const Text('Profile Edit');
  }
}

enum Mode { me, group }
