import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upgrader/upgrader.dart';

import '/models/profile_data.dart';
import '/screens/home/home.dart';
import '/screens/profile/profile.dart';
import '/screens/study/1study.dart';
import '/widgets/custom_drawer.dart';

class NewHomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  int _currentIndex = 0;

  ProfileData? profileData;
  List<Widget>? screensList;

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

      var topicSource =
          '${profileData!.university} ${profileData!.department} ${profileData!.information.batch!}';
      var topic = topicSource.replaceAll(' ', '_').toLowerCase();
      log('topic: $topic');

      if (!kIsWeb) {
        FirebaseMessaging.instance.subscribeToTopic(topic);
      }

      //
      screensList = [
        Home(profileData: profileData!),
        Study(profileData: profileData!),
        Profile(profileData: profileData!),
      ];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 800;

    return UpgradeAlert(
      child: Scaffold(
        drawer: const CustomDrawer(),
        bottomNavigationBar: isSmallScreen ? newBottomNav() : null,
        body: Row(
          children: [
            if (!isSmallScreen)
              NavigationRail(
                labelType: NavigationRailLabelType.all,
                unselectedLabelTextStyle:
                    TextStyle(color: Colors.blueGrey.shade400),
                selectedLabelTextStyle:
                    TextStyle(color: Colors.blueAccent.shade200),
                groupAlignment: 0,
                // backgroundColor: Colors.blueAccent.shade100.withOpacity(.08),
                indicatorColor: Colors.blueAccent.shade100.withOpacity(.2),
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) =>
                    setState(() => _currentIndex = index),

                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined,
                        color: Colors.blueGrey.shade400),
                    selectedIcon: Icon(
                      Icons.home,
                      color: Colors.blueAccent.shade200,
                    ),
                    label: const Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.school_outlined,
                        color: Colors.blueGrey.shade400),
                    selectedIcon: Icon(
                      Icons.school,
                      color: Colors.blueAccent.shade200,
                    ),
                    label: const Text('Study'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outline,
                        color: Colors.blueGrey.shade400),
                    selectedIcon: Icon(
                      Icons.person,
                      color: Colors.blueAccent.shade200,
                    ),
                    label: const Text('Profile'),
                  ),
                ],
              ),

            //
            Expanded(
              child: profileData == null
                  ? Center(
                      child: SpinKitFoldingCube(
                        size: 64,
                        color: Colors.blueAccent.shade100,
                      ),
                    )
                  : screensList![_currentIndex],
            ),
          ],
        ),
      ),
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

//
}
