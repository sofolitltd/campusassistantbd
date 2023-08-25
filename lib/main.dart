import '/auth/new_home_screen.dart';
import '/screens/community/notice/notice_screen.dart';

import '/services/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_strategy/url_strategy.dart';

import 'auth/new_splash_screen.dart';
import 'services/firebase_options.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // init firebase
  WidgetsFlutterBinding.ensureInitialized();

  // test devices
  List<String> devices = ["51FE053E52184B1F4740F5EE7C51E10B"];
  //admob init
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
    RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: devices,
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  }

  //firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // fcm
  if (!kIsWeb) {
    await FirebaseApi().initNotifications();
  }

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
      navigatorKey: navigatorKey,
      routes: {
        NoticeScreen.routeName: (context) => const NoticeScreen(),
        NewHomeScreen.routeName: (context) => const NewHomeScreen(),
      },
      home: const NewSplashScreen(),
    );
  }
}
