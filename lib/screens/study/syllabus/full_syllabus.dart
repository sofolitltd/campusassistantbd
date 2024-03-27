import 'package:campusassistant/screens/study/syllabus/syllabus_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/models/profile_data.dart';
import 'syllabus_card.dart';
import 'syllabus_card_web.dart';

class FullSyllabus extends StatelessWidget {
  const FullSyllabus({
    super.key,
    required this.university,
    required this.department,
    required this.profileData,
  });

  final ProfileData profileData;
  final String university;
  final String department;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Full Syllabus'),
      ),
      // add course
      floatingActionButton: (profileData.information.status!.moderator! == true)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSyllabus(
                      university: university,
                      department: department,
                      profileData: profileData,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(university)
            .collection('Departments')
            .doc(department)
            .collection('syllabusFull')
            .orderBy('contentTitle', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No data Found!'));
          }

          var data = snapshot.data!.docs;

          //
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: data.length,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 12,
              vertical: 12,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              var contentData = data[index];

              // for web browser
              if (kIsWeb) {
                //todo:
                return SyllabusCardWeb(contentData: contentData);
              }

              //for mobile
              return SyllabusCard(
                university: university,
                department: department,
                profileData: profileData,
                contentModel: contentData,
              );
            },
          );
        },
      ),
    );
  }
}
