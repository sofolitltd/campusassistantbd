import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_strategy/url_strategy.dart';

import 'auth/new_splash_screen.dart';
import 'services/firebase_options.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

void main() async {
  // init firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // remove # in web
  setPathUrlStrategy();

  // run main app
  runApp(const MyApp());
}

//
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      darkTheme: darkThemeData(context),
      theme: lightThemeData(context),
      home: const NewSplashScreen(),
    );
  }
}
