import 'package:campusassistant/auth/new/new_home_screen.dart';
import 'package:campusassistant/auth/new/new_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const NewHomeScreen();
        } else {
          return const NewLoginScreen();
        }
      },
    );
  }
}
