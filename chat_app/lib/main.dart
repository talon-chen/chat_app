import 'package:flutter/material.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlashChat());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const WelcomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: 'regist',
          builder: (BuildContext context, GoRouterState state) {
            return const RegistrationScreen();
          },
        ),
        GoRoute(
          path: 'chat',
          builder: (BuildContext context, GoRouterState state) {
            return const ChatScreen();
          },
        ),
      ],
    ),
  ],
);

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
