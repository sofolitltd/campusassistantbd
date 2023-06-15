import 'package:campusassistant/models/course_model_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/widgets/headline.dart';
import '../../../models/profile_data.dart';
import 'course_card.dart';

class CourseCategoryCard extends StatelessWidget {
  const CourseCategoryCard({
    Key? key,
    required this.profileData,
    required this.courseCategory,
    required this.selectedYear,
    required this.selectedBatch,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String courseCategory;
  final String selectedYear;
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
              .doc(profileData.university)
              .collection('Departments')
              .doc(profileData.department)
              .collection('courses')
              .orderBy('courseCode')
              .where('courseYear', isEqualTo: selectedYear)
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

                      // log("courseId: ${data[index].id}");
                      //
                      return CourseCard(
                        profileData: profileData,
                        selectedYear: selectedYear,
                        courseId: data[index].id,
                        courseModel: courseModel,
                        selectedSession: selectedBatch,
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
