import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:url_strategy/url_strategy.dart';

import '/auth/new/new_login_screen.dart';
import '/auth/new/new_splash_screen.dart';
import '/student/profile/profile.dart';
import '/student/study/course1_screen.dart';
import '/teacher/home/explore/cr/cr.dart';
import '/teacher/home/explore/university/university.dart';
import '/teacher/home/more/clubs/clubs.dart';
import '/teacher/home/more/emergency/emergency.dart';
import '/teacher/home/more/routine/routine.dart';
import '/teacher/home/more/syllabus/syllabus.dart';
import '/teacher/home/more/transports/transports.dart';
import '/teacher/study/archive/library.dart';
import '/teacher/study/archive/research.dart';
import '/utils/theme.dart';
import 'admin/admin_login.dart';
import 'services/firebase_options.dart';
import 'teacher/home/explore/about/about.dart';
import 'teacher/home/explore/staff/staff.dart';
import 'teacher/home/explore/student/all_student_screen.dart';
import 'teacher/home/explore/teacher/teacher.dart';
import 'utils/constants.dart';

// import 'student/home/More/clubs.dart';
// import 'student/home/More/routine/routine.dart';
// import 'student/home/More/syllabus/syllabus.dart';
// import 'student/home/More/transports/transports.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // remove # in web
  setPathUrlStrategy();

  // force to stick portrait screen
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then(
    (value) => runApp(const MyApp()),
  );
}

//
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      darkTheme: darkThemeData(context),
      theme: lightThemeData(context),
      routes: routes,
      // initialRoute: WrapperScreen.routeName,
      initialRoute: '/',
      // home: const NewLoginScreen(),
    );
  }
}

// route
Map<String, Widget Function(BuildContext)> routes = {
  //
  // SplashScreen.routeName: (context) => const SplashScreen(),
  // WrapperScreen.routeName: (context) => const WrapperScreen(),
  // WelcomeScreen.routeName: (context) => const WelcomeScreen(),

  // DashboardScreen.routeName: (context) => const DashboardScreen(),
  // LoginScreen.routeName: (context) => const LoginScreen(),
  // Verification.routeName: (context) => const Verification(),

  // home
  // HomeScreen.routeName: (context) => const HomeScreen(),

  //more
  // Emergency.routeName: (context) => const Emergency(),
  // Syllabus.routeName: (context) => const Syllabus(),
  // Routine.routeName: (context) => const Routine(),
  // Transports.routeName: (context) => const Transports(),
  // Clubs.routeName: (context) => const Clubs(),

  //todo: change
  '/': (context) => const NewSplashScreen(),
  NewLoginScreen.routeName: (context) => const NewLoginScreen(),
  Routine.routeName: (context) => const Routine(),
  Emergency.routeName: (context) => const Emergency(),
  Syllabus.routeName: (context) => const Syllabus(),
  Transports.routeName: (context) => const Transports(),
  Clubs.routeName: (context) => const Clubs(),

  // TeacherScreen.routeName: (context) => const TeacherScreen(),
  Teacher.routeName: (context) => const Teacher(),
  About.routeName: (context) => const About(),
  AllStudentScreen.routeName: (context) => const AllStudentScreen(),
  Cr.routeName: (context) => const Cr(),
  Staff.routeName: (context) => const Staff(),
  University.routeName: (context) => const University(),

  // archive
  Library.routeName: (context) => const Library(),
  Research.routeName: (context) => const Research(),

  // TeacherDetailsScreen.routeName: (context) => const TeacherDetailsScreen(),

  // StudentScreen.routeName: (context) => const StudentScreen(),

  // OfficeScreen.routeName: (context) => const OfficeScreen(),

  // AboutScreen.routeName: (context) => const AboutScreen(),

  // study
  CourseScreen.routeName: (context) => const CourseScreen(),
  // CourseScreen2.routeName: (context) => const CourseScreen2(),

  //profile
  ProfileScreen.routeName: (context) => const ProfileScreen(),

  //admin
  AdminLogin.routeName: (context) => const AdminLogin(),
};
