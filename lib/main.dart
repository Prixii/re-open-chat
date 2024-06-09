import 'package:flutter/material.dart';
import 'package:re_open_chat/bloc/application/application_bloc.dart';
import 'package:re_open_chat/bloc/chat_manager/chat_manager_bloc.dart';
import 'package:re_open_chat/bloc/contact_manager/contact_manager_bloc.dart';
import 'package:re_open_chat/bloc/global/global_bloc.dart';
import 'package:re_open_chat/bloc/message/message_bloc.dart';
import 'package:re_open_chat/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final globalBloc = GlobalBloc();
final contactManagerBloc = ContactManagerBloc();
final messageBloc = MessageBloc();
final chatManagerBloc = ChatManagerBloc();
final applicationBloc = ApplicationBloc();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => globalBloc),
        BlocProvider(create: (context) => messageBloc),
        BlocProvider(create: (context) => chatManagerBloc),
        BlocProvider(create: (context) => contactManagerBloc),
        BlocProvider(create: (context) => applicationBloc),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4),
          useMaterial3: true,
          dividerColor: Colors.grey[300],
        ),
      ),
    );
  }
}
