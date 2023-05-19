import 'package:chat_app/component/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  late final dynamic user;
  bool userIsloggedIn = false;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    user = _auth.currentUser;

    // TODO: not working yet
    if (user != null) {
      userIsloggedIn = true;
    } else {
      userIsloggedIn = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 60.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Flash Chat'),
                    ],
                  ),
                ),
              ),
            ]),
            const SizedBox(
              height: 48.0,
            ),
            userIsloggedIn
                ? RoundedButton(
                    title: 'Welcome back! ${user.email}',
                    colour: Colors.blueAccent,
                    onPressed: () => context.go('/chat'),
                  )
                : RoundedButton(
                    title: 'Log In',
                    colour: Colors.blueAccent,
                    onPressed: () => context.go('/login'),
                  ),
            RoundedButton(
              title: 'Register',
              colour: Colors.lightBlueAccent,
              onPressed: () => context.go('/regist'),
            ),
          ],
        ),
      ),
    );
  }
}
