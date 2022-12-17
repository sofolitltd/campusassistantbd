import 'package:flutter/material.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  //
  static const routeName = '/teacher_dashboard';

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('data'),
    );
  }
}
