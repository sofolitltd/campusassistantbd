import 'package:campusassistant/models/profile_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/study/1_study.dart';
import '/admin/batches_screen.dart';
import '/admin/sessions_screen.dart';
import '/admin/student_all_screen.dart';

class DepartmentDetails extends StatelessWidget {
  const DepartmentDetails(
      {super.key, required this.university, required this.department});

  final String university;
  final String department;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              department,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              university,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),

      //
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width * .2
              : 16,
          vertical: 16,
        ),
        children: [
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Batches'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BatchesScreen(
                    university: university,
                    department: department,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Sessions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SessionsScreen(
                    university: university,
                    department: department,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Students'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllStudentScreen(
                    university: university,
                    department: department,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Study'),
            onTap: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots()
                  .forEach((data) {
                ProfileData profileData = ProfileData.fromJson(data.data());

                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Study(
                      university: university,
                      department: department,
                      profileData: profileData,
                      screenFor: 'admin',
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
