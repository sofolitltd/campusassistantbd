import 'package:flutter/material.dart';

import '/utils/constants.dart';
import '../../models/profile_data.dart';
import 'upload/course_add.dart';
import 'widgets/course_category_card.dart';

class Courses extends StatelessWidget {
  static const routeName = '/courses';

  const Courses({
    Key? key,
    required this.profileData,
    required this.semester,
    required this.selectedBatch,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String semester;
  final String selectedBatch;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Courses ($semester)'),
      ),

      // add course
      floatingActionButton: (profileData.information.status!.moderator! == true)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCourse(
                      profileData: profileData,
                      semester: semester,
                      batches: batches,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      //body
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1000
              ? MediaQuery.of(context).size.width * .2
              : 8,
        ),
        children: kCourseCategory
            .map(
              (courseCategory) => CourseCategoryCard(
                courseCategory: courseCategory,
                profileData: profileData,
                selectedYear: semester,
                selectedBatch: selectedBatch,
                batches: batches,
              ),
            )
            .toList(),
      ),
    );
  }
}
