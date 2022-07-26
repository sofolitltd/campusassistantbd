import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/providers/user_provider.dart';
import '/screens/auth/login.dart';
import '/screens/auth/signup1.dart';
import '/screens/auth/welcome.dart';
import '/screens/auth/wrapper.dart';
import '/screens/dashboard/dashboard.dart';
import '/screens/home/about/about_screen.dart';
import '/screens/home/home.dart';
import '/screens/home/office/office_screen.dart';
import '/screens/home/student/student_screen.dart';
import '/screens/home/teacher/teacher_screen.dart';
import '/screens/profile/profile.dart';
import '/screens/study/course1_screen.dart';
import '/utils/theme.dart';
import 'services/firebase_options.dart';
import 'utils/constants.dart';

// notification
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
// }

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // remove # in web
  // setPathUrlStrategy();

  // force to stick portrait screen
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]).then(
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

//
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      darkTheme: darkThemeData(context),
      theme: lightThemeData(context),
      initialRoute: WrapperScreen.routeName,
      routes: routes,
    );
  }
}

// route
Map<String, Widget Function(BuildContext)> routes = {
  //
  // SplashScreen.routeName: (context) => const SplashScreen(),
  WrapperScreen.routeName: (context) => const WrapperScreen(),
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),

  DashboardScreen.routeName: (context) => const DashboardScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  SignUpScreen1.routeName: (context) => const SignUpScreen1(),

  // home
  HomeScreen.routeName: (context) => const HomeScreen(),

  TeacherScreen.routeName: (context) => const TeacherScreen(),
  // TeacherDetailsScreen.routeName: (context) => const TeacherDetailsScreen(),

  StudentScreen.routeName: (context) => const StudentScreen(),

  // AllBatchList.routeName: (context) => const AllBatchList(),

  OfficeScreen.routeName: (context) => const OfficeScreen(),

  AboutScreen.routeName: (context) => const AboutScreen(),

  // study
  CourseScreen.routeName: (context) => const CourseScreen(),
  // CourseScreen2.routeName: (context) => const CourseScreen2(),

  //profile
  ProfileScreen.routeName: (context) => const ProfileScreen(),
};
