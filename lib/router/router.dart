import 'package:go_router/go_router.dart';
import 'package:re_open_chat/view/application_manager.dart';
import 'package:re_open_chat/view/chat.dart';
import 'package:re_open_chat/view/contact_detail.dart';
import 'package:re_open_chat/view/hello.dart';
import 'package:re_open_chat/view/home.dart';
import 'package:re_open_chat/view/profile_edit.dart';
import 'package:re_open_chat/view/splash.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      name: 'hello',
      path: '/hello',
      builder: (context, state) => const Hello(),
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => const Home(),
      routes: [
        GoRoute(
          name: 'chat',
          path: 'chat',
          builder: (context, state) => const ChatPage(),
        ),
        GoRoute(
          name: 'contact-detail',
          path: 'contact-detail',
          builder: (context, state) => const ContactDetail(),
        ),
        GoRoute(
          name: 'application-manager',
          path: 'application-manager',
          builder: (context, state) => const ApplicationManager(),
        ),
        GoRoute(
          name: 'profile-edit',
          path: 'profile-edit',
          builder: (context, state) => const ProfileEdit(),
        )
      ],
    ),
  ],
);
