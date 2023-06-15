import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/chapter_model.dart';
import '/models/course_model_new.dart';
import '/models/profile_data.dart';
import '/screens/study/upload/chapter_add.dart';
import '/screens/study/upload/chapter_edit.dart';
import '5course_notes_details.dart';

class CourseNotesChapters extends StatelessWidget {
  const CourseNotesChapters({
    Key? key,
    required this.profileData,
    required this.selectedYear,
    // required this.id,
    required this.courseType,
    required this.courseModel,
    required this.selectedBatch,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedYear;
  // final String id;
  final String courseType;
  final CourseModelNew courseModel;
  final String selectedBatch;
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
                      selectedYear: selectedYear,
                      // id: id,
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
            .doc(profileData.university)
            .collection('Departments')
            .doc(profileData.department)
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
                    // notes details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseNotesDetails(
                          profileData: profileData,
                          selectedYear: selectedYear,
                          courseType: 'notes',
                          courseModel: courseModel,
                          // id: id,
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
                            profileData: profileData,
                            selectedYear: selectedYear,
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
