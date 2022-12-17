import 'package:campusassistant/screens/study/widgets/content_card_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/models/chapter_model.dart';
import '/models/content_model.dart';
import '/models/course_model.dart';
import '/models/user_model.dart';
import '/screens/study/upload/add_content.dart';
import '/screens/study/widgets/bookmark_counter.dart';
import '/screens/study/widgets/content_card.dart';
import '../../services/database_service.dart';
import '../../utils/constants.dart';

class CourseNotesDetails extends StatelessWidget {
  const CourseNotesDetails({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    required this.courseType,
    required this.courseModel,
    required this.courseChapterModel,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final String courseType;
  final CourseModel courseModel;
  final ChapterModel courseChapterModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
            '${courseChapterModel.chapterNo}. ${courseChapterModel.chapterTitle}'),

        // bookmark
        actions: [
          BookmarkCounter(
            userModel: userModel,
          ),
        ],
      ),
      // add notes
      floatingActionButton: (userModel.role[UserRole.cr.name])
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddContent(
                      userModel: userModel,
                      selectedYear: selectedYear,
                      id: id,
                      courseType: 'Notes',
                      courseModel: courseModel,
                      chapterNo: courseChapterModel.chapterNo,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.refUniversities
            .doc(userModel.university)
            .collection('Departments')
            .doc(userModel.department)
            .collection('Notes')
            .where('status', whereIn: ['Basic', userModel.status])
            .where('courseCode', isEqualTo: courseModel.courseCode)
            .where('lessonNo', isEqualTo: courseChapterModel.chapterNo)
            .where('sessionList', arrayContains: userModel.session)
            .orderBy('contentTitle')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No notes found!'));
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

              //
              if (kIsWeb) {
                return ContentCardWeb(
                  userModel: userModel,
                  courseContentModel: courseContentModel,
                );
              }
              //
              return ContentCard(
                userModel: userModel,
                courseContentModel: courseContentModel,
              );
            },
          );
        },
      ),
    );
  }
}

//
// class ChapterNotes extends StatelessWidget {
//   const ChapterNotes({
//     Key? key,
//     required this.userModel,
//     required this.selectedYear,
//     required this.id,
//     required this.courseType,
//     required this.courseChapterModel,
//     required this.courseModel,
//   }) : super(key: key);
//
//   final UserModel userModel;
//   final ChapterModel courseChapterModel;
//   final CourseModel courseModel;
//   final String selectedYear;
//   final String id;
//   final String courseType;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // add notes
//       floatingActionButton: (userModel.role[UserRole.cr.name])
//           ? FloatingActionButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => AddContent(
//                               userModel: userModel,
//                               selectedYear: selectedYear,
//                               id: id,
//                               courseType: 'Notes',
//                               courseModel: courseModel,
//                               chapterNo: courseChapterModel.chapterNo,
//                             )));
//               },
//               child: const Icon(Icons.add),
//             )
//           : null,
//
//       body: StreamBuilder<QuerySnapshot>(
//           stream: DatabaseService.refUniversities
//               .doc(userModel.university)
//               .collection('Departments')
//               .doc(userModel.department)
//               .collection('Notes') // todo: need to fix
//               .where('sessionList', arrayContains: userModel.session)
//               .where('lessonNo', isEqualTo: courseChapterModel.chapterNo)
//               .where('status', isEqualTo: userModel.status)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Center(child: Text('Something wrong'));
//             }
//
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (snapshot.data!.size == 0) {
//               return const Center(child: Text('No notes found!'));
//             }
//
//             var data = snapshot.data!.docs;
//
//             //
//             return ListView.separated(
//               itemCount: data.length,
//               separatorBuilder: (BuildContext context, int index) =>
//                   const SizedBox(height: 12),
//               padding: const EdgeInsets.all(12),
//               itemBuilder: (context, index) {
//                 //model
//                 ContentModel courseContentModel =
//                     ContentModel.fromJson(data[index]);
//                 // print(courseContentModel.status);
//
//                 var contentData = data[index];
//
//                 //
//                 if (kIsWeb) {
//                   return ContentCardWeb(
//                     userModel: userModel,
//                     contentData: contentData,
//                     courseContentModel: courseContentModel,
//                   );
//                 }
//                 //
//                 return ContentCard(
//                   userModel: userModel,
//                   contentData: contentData,
//                   courseContentModel: courseContentModel,
//                   selectedYear: selectedYear,
//                   id: id,
//                   courseType: courseType,
//                   courseModel: courseModel,
//                 );
//               },
//             );
//           }),
//     );
//   }
// }
