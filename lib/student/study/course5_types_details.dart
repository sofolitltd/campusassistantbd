import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/models/content_model.dart';
import '/models/course_model.dart';
import '/models/user_model.dart';
import '../../utils/constants.dart';
import 'upload/add_content.dart';
import 'widgets/content_card.dart';
import 'widgets/content_card_web.dart';

class CourseTypesDetails extends StatelessWidget {
  const CourseTypesDetails({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    required this.courseType,
    required this.courseModel,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final String courseType;
  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // add content
      floatingActionButton: (userModel.role[UserRole.cr.name])
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddContent(
                              id: id,
                              userModel: userModel,
                              selectedYear: selectedYear,
                              courseType: courseType,
                              courseModel: courseModel,
                            )));
              },
              child: const Icon(Icons.add),
            )
          : null,

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc(userModel.university)
              .collection('Departments')
              .doc(userModel.department)
              .collection(courseType)
              .where('courseCode', isEqualTo: courseModel.courseCode)
              // .where('batchList', arrayContains: userModel.batch)
              .where('status', whereIn: ['Basic', userModel.status])
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

                var contentData = data[index];

                //
                if (kIsWeb) {
                  return ContentCardWeb(
                    userModel: userModel,
                    courseContentModel: courseContentModel,
                  );
                }

                //
                return ContentCard(
                  // userModel: userModel,
                  courseContentModel: courseContentModel,
                );
              },
            );
          }),
    );
  }
}
