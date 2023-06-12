import 'package:campusassistant/models/profile_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../8course_bookmarks.dart';

class BookmarkCounter extends StatelessWidget {
  const BookmarkCounter({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    //todo: fix ref
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Universities")
            .doc(profileData.university)
            .collection('Departments')
            .doc(profileData.department)
            .collection('Bookmarks')
            .doc(profileData.email)
            .collection('Contents')
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
            return const Text('');
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
                  ),
                ),
              );
            },
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 24,
              ),
              margin: const EdgeInsets.only(right: 8, top: 16, bottom: 16),
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
