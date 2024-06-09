import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/global/global_event.dart';
import 'package:re_open_chat/bloc/global/global_state.dart';
import 'package:re_open_chat/components/application_manager/application_list.dart';
import 'package:re_open_chat/main.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:re_open_chat/utils/context_reader.dart';

class ApplicationManager extends StatefulWidget {
  const ApplicationManager({super.key});

  @override
  State<ApplicationManager> createState() => _ApplicationManagerState();
}

class _ApplicationManagerState extends State<ApplicationManager> {
  @override
  void initState() {
    super.initState();
    globalBloc
        .add(const SwitchAppPage(currentPage: AppPage.applicationManager));
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
      child: const ApplicationManagerBody(),
    );
  }
}

class ApplicationManagerBody extends StatelessWidget {
  const ApplicationManagerBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = readThemeData(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: theme.colorScheme.shadow,
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        title: const Text('Applications'),
      ),
      body: const ApplicationList(),
    );
  }
}
