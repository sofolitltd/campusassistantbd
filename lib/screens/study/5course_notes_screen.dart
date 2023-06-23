import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/chapter_model.dart';
import '/models/content_model.dart';
import '/models/course_model_new.dart';
import '/models/profile_data.dart';
import '/screens/study/uploader/content_add.dart';
import 'widgets/bookmark_counter.dart';
import 'widgets/content_card.dart';

class CourseNotesScreens extends StatelessWidget {
  const CourseNotesScreens({
    Key? key,
    required this.profileData,
    required this.selectedSemester,
    required this.selectedBatch,
    required this.courseType,
    required this.courseModel,
    required this.chapterModel,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedSemester;
  final String selectedBatch;
  final String courseType;
  final CourseModelNew courseModel;
  final ChapterModel chapterModel;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    var subscriber = profileData.information.status!.subscriber!;
    log(subscriber);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text('${chapterModel.chapterNo}. ${chapterModel.chapterTitle}'),

        // bookmark
        actions: [
          // bookmark counter
          BookmarkCounter(
            profileData: profileData,
            batches: batches,
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: (profileData.information.status!.moderator! ||
              (profileData.information.status!.cr! &&
                  selectedBatch == profileData.information.batch))
          ? FloatingActionButton(
              onPressed: () {
                log(courseType);
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
                      chapterNo: chapterModel.chapterNo,
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
            .collection('notes')
            .where('status', whereIn: ['basic', subscriber])
            .where('courseCode', isEqualTo: courseModel.courseCode)
            .where('lessonNo', isEqualTo: chapterModel.chapterNo)
            .where('batches', arrayContains: selectedBatch)
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
                const SizedBox(height: 16),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 12,
              vertical: 12,
            ),
            itemBuilder: (context, index) {
              //model
              ContentModel contentModel = ContentModel.fromJson(data[index]);
              log('contentId: ${contentModel.contentId}');

              //
              return ContentCard(
                selectedSemester: selectedSemester,
                selectedBatch: selectedBatch,
                profileData: profileData,
                contentModel: contentModel,
                batches: batches,
              );
            },
          );
        },
      ),
    );
  }
}
