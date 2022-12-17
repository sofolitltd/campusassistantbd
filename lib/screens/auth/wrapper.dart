import 'package:campusassistant/screens/auth/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/screens/dashboard/dashboard.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const DashboardScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
