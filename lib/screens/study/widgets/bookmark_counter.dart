import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../8_course_bookmarks.dart';
import '/models/profile_data.dart';

class BookmarkCounter extends StatelessWidget {
  const BookmarkCounter({
    super.key,
    required this.profileData,
    required this.batches,
  });

  final ProfileData profileData;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    //
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Universities")
            .doc(profileData.university)
            .collection('Departments')
            .doc(profileData.department)
            .collection('bookmarks')
            .doc(profileData.email)
            .collection('contents')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('');
          }

          var data = snapshot.data!.size;

          if (data == 0) {
            return Container();
          }
          //
          return GestureDetector(
            onTap: () {
              //
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseBookMarks(
                    profileData: profileData,
                    batches: batches,
                  ),
                ),
              );
            },
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 28,
              ),
              margin: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  // shape: BoxShape.circle,
                  // border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(3)),
              child: Text(
                data.toString(),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }
}
