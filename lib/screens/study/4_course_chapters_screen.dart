import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/chapter_model.dart';
import '/models/course_model_new.dart';
import '/models/profile_data.dart';
import '5_course_notes_screen.dart';
import 'uploader/chapter_add.dart';
import 'uploader/chapter_edit.dart';

class CourseChaptersScreen extends StatelessWidget {
  const CourseChaptersScreen({
    super.key,
    required this.university,
    required this.department,
    required this.profileData,
    required this.selectedSemester,
    required this.selectedBatch,
    required this.courseType,
    required this.courseModel,
    required this.batches,
  });

  final String university;
  final String department;
  final ProfileData profileData;
  final String selectedSemester;
  final String selectedBatch;
  final String courseType;
  final CourseModelNew courseModel;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // add chapter
      floatingActionButton: (profileData.information.status!.moderator! == true)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddChapter(
                      profileData: profileData,
                      selectedYear: selectedSemester,
                      courseModel: courseModel,
                      courseType: courseType,
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
            .doc(university)
            .collection('Departments')
            .doc(department)
            .collection('chapters')
            .where('batches', arrayContains: selectedBatch)
            .where('courseCode', isEqualTo: courseModel.courseCode)
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
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 15),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 12,
              vertical: 12,
            ),
            itemBuilder: (context, index) {
              //model
              ChapterModel chapterModel = ChapterModel.fromJson(data[index]);
              //
              return Card(
                elevation: 3,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: () {
                    // notes screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseNotesScreens(
                          university: university,
                          department: department,
                          profileData: profileData,
                          selectedSemester: selectedSemester,
                          selectedBatch: selectedBatch,
                          courseType: 'Notes',
                          courseModel: courseModel,
                          chapterModel: chapterModel,
                          batches: batches,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    // edit chapter
                    if (profileData.information.status!.moderator! == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditChapter(
                            university: university,
                            department: department,
                            selectedYear: selectedSemester,
                            courseModel: courseModel,
                            courseType: courseType,
                            batches: batches,
                            chapterId: data[index].id,
                            chapterModel: chapterModel,
                          ),
                        ),
                      );
                    }
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
                    child: Text(
                      '${chapterModel.chapterNo}',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
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
