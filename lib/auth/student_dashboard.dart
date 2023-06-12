import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../student/archive/archive_screen.dart';
import '../student/home/home.dart';
import '../student/profile/profile.dart';
import '../student/study/course1_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  //
  static const routeName = '/dashboard';

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int? _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // final args = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      bottomNavigationBar: width > 600
          ? null
          : SalomonBottomBar(
              // curve: Curves.easeInExpo,
              // itemPadding:
              //     const EdgeInsets.symmetric(vertical: 8, horizontal: 16),g
              unselectedItemColor: Colors.grey.shade500,
              currentIndex: _currentPageIndex!,
              onTap: (i) => setState(() => _currentPageIndex = i),
              items: [
                /// Home
                SalomonBottomBarItem(
                  icon: const Icon(Icons.home_outlined),
                  title: const Text("Home"),
                  selectedColor: Colors.blue,
                ),

                /// Likes
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
            ),
      // : NavigationBar(
      //     onDestinationSelected: (int index) {
      //       setState(() {
      //         _currentPageIndex = index;
      //       });
      //     },
      //     selectedIndex: _currentPageIndex!,
      //     destinations: const [
      //       NavigationDestination(
      //         selectedIcon: Icon(Icons.home),
      //         icon: Icon(Icons.home_outlined),
      //         label: 'Home',
      //       ),
      //       NavigationDestination(
      //         selectedIcon: Icon(Icons.school),
      //         icon: Icon(Icons.school_outlined),
      //         label: 'Study',
      //       ),
      //       NavigationDestination(
      //         selectedIcon: Icon(Icons.photo_library_rounded),
      //         icon: Icon(Icons.photo_library_outlined),
      //         label: 'Archive',
      //       ),
      //       NavigationDestination(
      //         selectedIcon: Icon(Icons.person),
      //         icon: Icon(Icons.person_outlined),
      //         label: 'Profile',
      //       ),
      //     ],
      //   ),

      //
      body: Row(
        children: [
          if (width > 600)
            NavigationRail(
              groupAlignment: 0,
              selectedIndex: _currentPageIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
              labelType: NavigationRailLabelType.all,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  selectedIcon: Icon(Icons.school),
                  icon: Icon(Icons.school_outlined),
                  label: Text('Study'),
                ),
                NavigationRailDestination(
                  selectedIcon: Icon(Icons.photo_library_rounded),
                  icon: Icon(Icons.photo_library_outlined),
                  label: Text('Archive'),
                ),
                NavigationRailDestination(
                  selectedIcon: Icon(Icons.person),
                  icon: Icon(Icons.person_outlined),
                  label: Text('Profile'),
                ),
              ],
            ),
          // const VerticalDivider(thickness: 1, width: 1),

          // This is the main content.
          Expanded(flex: 10, child: screensList[_currentPageIndex!]),
        ],
      ),
    );
  }

  //
  List screensList = const [
    HomeScreen(),
    CourseScreen(),
    ArchiveScreen(),
    ProfileScreen(),
  ];
}
