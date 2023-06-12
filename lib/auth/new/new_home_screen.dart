import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '/teacher/profile/profile.dart';
import '/teacher/study/1study.dart';
import '../../models/profile_data.dart';
import '../../teacher/home/home.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({Key? key}) : super(key: key);
  static const routeName = '/dashboard';

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  int _currentIndex = 0;

  ProfileData? profileData;
  List? screensList;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  //
  getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .forEach((data) {
      profileData = ProfileData.fromJson(data.data());

      //
      screensList = [
        Home(profileData: profileData!),
        Study(profileData: profileData!),
        // const Community(),
        Profile(profileData: profileData!),
      ];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      bottomNavigationBar: newBottomNav(),
      body: profileData == null
          ? Center(
              child: SpinKitFoldingCube(
                size: 64,
                color: Colors.purple.shade100,
              ),
            )
          : screensList![_currentIndex],
    );
  }

  // bottom nav
  newBottomNav() {
    return NavigationBar(
      height: 64,
      backgroundColor: Colors.blueAccent.shade100.withOpacity(.08),
      indicatorColor: Colors.blueAccent.shade100.withOpacity(.2),
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) => setState(() => _currentIndex = index),
      destinations: [
        /// Home
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: Colors.blueGrey.shade400),
          selectedIcon: Icon(Icons.home, color: Colors.blueAccent.shade200),
          label: "Home",
          tooltip: "Home",
        ),

        /// study
        NavigationDestination(
          icon: Icon(Icons.school_outlined, color: Colors.blueGrey.shade400),
          selectedIcon: Icon(Icons.school, color: Colors.blueAccent.shade200),
          label: "Study",
          tooltip: "Study",
        ),

        ///
        // NavigationDestination(
        //   icon: Icon(Icons.message_outlined, color: Colors.blueGrey.shade400),
        //   selectedIcon: Icon(Icons.message, color: Colors.blueAccent.shade200),
        //   label: "Community",
        //   tooltip: "Community",
        // ),

        /// Profile
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: Colors.blueGrey.shade400),
          selectedIcon: Icon(Icons.person, color: Colors.blueAccent.shade200),
          label: "Profile",
          tooltip: "Profile",
        ),
      ],
    );
  }
}
