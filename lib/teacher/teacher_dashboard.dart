import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '/teacher/attendance.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);
  static const routeName = '/dashboard';

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      bottomNavigationBar: teacherBottomNav(),
      body: screensList[_currentIndex],
    );
  }

  //
  teacherBottomNav() {
    return SalomonBottomBar(
      // curve: Curves.easeInExpo,
      // itemPadding:
      //     const EdgeInsets.symmetric(vertical: 8, horizontal: 16),g
      unselectedItemColor: Colors.grey.shade500,
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: [
        /// Home
        SalomonBottomBarItem(
          icon: const Icon(Icons.home_outlined),
          title: const Text("Home"),
          selectedColor: Colors.blue,
        ),

        /// study
        SalomonBottomBarItem(
          icon: const Icon(Icons.school_outlined),
          title: const Text("Study"),
          selectedColor: Colors.purple,
        ),

        /// Search
        SalomonBottomBarItem(
          icon: const Icon(Icons.style_outlined),
          title: const Text("Library"),
          selectedColor: Colors.deepOrange,
        ),

        /// Profile
        SalomonBottomBarItem(
          icon: const Icon(Icons.person_outline),
          title: const Text("Profile"),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }
}

//
List screensList = const [
  // Home(),
  // Study(),
  // Archive(),
  // Profile(),
];

//
attendance(context) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Text(
            'Hello Sir',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 16),
          //
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              //
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Attendance()));
            },
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: const Column(
                children: [
                  Expanded(
                    child: Placeholder(),
                  ),

                  //
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Attendance'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
