import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/content_model.dart';
import '/models/course_model_new.dart';
import '/models/profile_data.dart';
import 'uploader/content_add.dart';
import 'widgets/content_card.dart';

class CourseTypesDetails extends StatelessWidget {
  const CourseTypesDetails({
    Key? key,
    required this.profileData,
    required this.selectedSemester,
    required this.selectedBatch,
    required this.courseType,
    required this.courseModel,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedSemester;
  final String selectedBatch;
  final String courseType;
  final CourseModelNew courseModel;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    var subscriber = profileData.information.status!.subscriber;

    return Scaffold(
      // add content
      floatingActionButton: (profileData.information.status!.moderator! ||
              (profileData.information.status!.cr! &&
                  selectedBatch == profileData.information.batch))
          ? FloatingActionButton(
              onPressed: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddContent(
                      profileData: profileData,
                      selectedSemester: selectedSemester,
                      courseType: courseType,
                      courseModel: courseModel,
                      batches: batches,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(profileData.university)
            .collection('Departments')
            .doc(profileData.department)
            .collection(courseType.toLowerCase())
            .where('status', whereIn: ['basic', subscriber])
            .where('courseCode', isEqualTo: courseModel.courseCode)
            .where('batches', arrayContains: selectedBatch)
            // .where('lessonNo', isEqualTo: courseType.lessonNo)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return Center(child: Text('No $courseType Found!'));
          }

          var data = snapshot.data!.docs;

          //
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 12),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 12,
              vertical: 12,
            ),
            itemBuilder: (context, index) {
              //model
              ContentModel courseContentModel =
                  ContentModel.fromJson(data[index]);

              //
              return ContentCard(
                profileData: profileData,
                selectedSemester: selectedSemester,
                selectedBatch: selectedBatch,
                contentModel: courseContentModel,
                batches: batches,
              );
            },
          );
        },
      ),
    );
  }
}
