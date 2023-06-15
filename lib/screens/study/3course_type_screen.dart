import 'package:flutter/material.dart';

import '/models/course_model_new.dart';
import '/utils/constants.dart';
import '../../models/profile_data.dart';
import '4course_notes_chapters.dart';
import '6course_types_details.dart';
import '7course_videos.dart';
import 'widgets/bookmark_counter.dart';

class CourseTypeScreen extends StatefulWidget {
  const CourseTypeScreen({
    Key? key,
    required this.profileData,
    // required this.id,
    required this.selectedYear,
    required this.courseModel,
    required this.selectedBatch,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedYear;

  // final String id;
  final CourseModelNew courseModel;
  final String selectedBatch;
  final List<String> batches;

  @override
  State<CourseTypeScreen> createState() => _CourseTypeScreenState();
}

class _CourseTypeScreenState extends State<CourseTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kCourseType.length,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          title: Text(
            '${widget.courseModel.courseCode} - ${widget.courseModel.courseTitle}',
          ),

          // tab bar
          bottom: TabBar(
            isScrollable: true,
            tabs: kCourseType
                .map((tab) => Tab(text: tab.toString().toUpperCase()))
                .toList(),
          ),

          actions: [
            //
            BookmarkCounter(
                profileData: widget.profileData, batches: widget.batches),
          ],
        ),

        //
        body: TabBarView(
          children: [
            // chapter list
            CourseNotesChapters(
              profileData: widget.profileData,
              selectedYear: widget.selectedYear,
              courseType: kCourseType[0],
              courseModel: widget.courseModel,
              selectedBatch: widget.selectedBatch,
              batches: widget.batches,
            ),

            // video list
            CourseVideos(
              profileData: widget.profileData,
              selectedYear: widget.selectedYear,
              // courseChapterModel: courseChapterModel,
              courseModel: widget.courseModel,
              batches: widget.batches,
            ),

            // books
            CourseTypesDetails(
              profileData: widget.profileData,
              selectedYear: widget.selectedYear,
              courseType: kCourseType[2],
              courseModel: widget.courseModel,
              batches: widget.batches,
            ),

            // questions
            CourseTypesDetails(
              profileData: widget.profileData,
              selectedYear: widget.selectedYear,
              courseType: kCourseType[3],
              courseModel: widget.courseModel,
              batches: widget.batches,
            ),

            // syllabus
            CourseTypesDetails(
              profileData: widget.profileData,
              selectedYear: widget.selectedYear,
              courseType: kCourseType[4],
              courseModel: widget.courseModel,
              batches: widget.batches,
            ),
          ],
        ),
      ),
    );
  }
}
