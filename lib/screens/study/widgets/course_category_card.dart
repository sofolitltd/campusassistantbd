import 'package:campusassistant/models/course_model_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/profile_data.dart';
import '/widgets/headline.dart';
import 'course_card.dart';

class CourseCategoryCard extends StatelessWidget {
  const CourseCategoryCard({
    super.key,
    required this.courseCategory,
    required this.university,
    required this.department,
    required this.profileData,
    required this.screenFor,
    required this.selectedSemester,
    required this.selectedBatch,
    required this.batches,
  });

  final String courseCategory;
  final String university;
  final String department;
  final ProfileData profileData;
  final String screenFor;
  final String selectedSemester;
  final String selectedBatch;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc(university)
              .collection('Departments')
              .doc(department)
              .collection('courses')
              .orderBy('courseCode')
              .where('courseYear', isEqualTo: selectedSemester)
              .where('courseCategory', isEqualTo: courseCategory)
              .where('batches', arrayContains: selectedBatch)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  child: const Center(child: CircularProgressIndicator()));
            }

            var data = snapshot.data!.docs;

            //
            if (data.isNotEmpty) {
              return Column(
                children: [
                  //
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 8,
                    ),
                    child: Headline(title: courseCategory),
                  ),

                  //
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    itemBuilder: (context, index) {
                      //model
                      CourseModelNew courseModel =
                          CourseModelNew.fromJson(data[index]);
                      //
                      return CourseCard(
                        university: university,
                        department: department,
                        profileData: profileData,
                        screenFor: screenFor,
                        selectedSemester: selectedSemester,
                        selectedBatch: selectedBatch,
                        courseId: data[index].id,
                        courseModel: courseModel,
                        batches: batches,
                      );
                    },
                  ),
                ],
              );
            }

            //
            return Container();
          },
        ),
      ],
    );
  }
}
