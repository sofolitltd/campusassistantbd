import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/chapter_model.dart';
import '/models/course_model.dart';
import '/models/user_model.dart';
import '/screens/study/upload/chapter_add.dart';
import '/screens/study/upload/chapter_edit.dart';
import '../../services/database_service.dart';
import '../../utils/constants.dart';
import 'course4_notes_details.dart';

class CourseNotesChapters extends StatelessWidget {
  const CourseNotesChapters({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    required this.courseType,
    required this.courseModel,
    required this.selectedSession,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final String courseType;
  final CourseModel courseModel;
  final String selectedSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      floatingActionButton: (userModel.role[UserRole.admin.name])
          ? FloatingActionButton(
              onPressed: () {
                // add chapter
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddChapter(
                              userModel: userModel,
                              selectedYear: selectedYear,
                              id: id,
                              courseModel: courseModel,
                              courseType: courseType,
                            )));
              },
              child: const Icon(Icons.add),
            )
          : null,

      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.refUniversities
            .doc(userModel.university)
            .collection('Departments')
            .doc(userModel.department)
            .collection('Chapters')
            .where('courseCode', isEqualTo: courseModel.courseCode)
            .where('sessionList', arrayContains: selectedSession)
            .orderBy('chapterNo')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No Chapters Found!'));
          }

          var data = snapshot.data!.docs;

          //
          return ListView.separated(
            shrinkWrap: true,
            itemCount: data.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 14),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 1000
                    ? MediaQuery.of(context).size.width * .2
                    : 12,
                vertical: 12),
            itemBuilder: (context, index) {
              //model
              ChapterModel chapterModel = ChapterModel.fromJson(data[index]);
              //
              return Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onLongPress: userModel.role[UserRole.admin.name]
                      ? () {
                          //todo: later
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditChapter(
                                userModel: userModel,
                                selectedYear: selectedYear,
                                id: data[index].id,
                                courseModel: courseModel,
                                chapterModel: chapterModel,
                                courseType: courseType,
                              ),
                            ),
                          );
                        }
                      : null,
                  onTap: () {
                    // notes details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseNotesDetails(
                          userModel: userModel,
                          selectedYear: selectedYear,
                          id: id,
                          courseType: courseType,
                          courseModel: courseModel,
                          courseChapterModel: chapterModel,
                        ),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  horizontalTitleGap: 12,
                  leading: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.amber.shade200,
                    ),
                    alignment: Alignment.center,
                    child: Text('${chapterModel.chapterNo}',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                  ),
                  title: Text(
                    chapterModel.chapterTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          // color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
