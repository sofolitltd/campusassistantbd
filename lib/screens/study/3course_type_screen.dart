import 'package:flutter/material.dart';

import '/models/course_model_new.dart';
import '/models/profile_data.dart';
import '/utils/constants.dart';
import '4course_chapters_screen.dart';
import '6course_types_details.dart';
import '7course_videos.dart';
import 'widgets/bookmark_counter.dart';

class CourseTypeScreen extends StatefulWidget {
  const CourseTypeScreen({
    Key? key,
    required this.profileData,
    required this.selectedSemester,
    required this.courseModel,
    required this.selectedBatch,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedSemester;
  final String selectedBatch;
  final CourseModelNew courseModel;
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
            tabs: kCourseType.map((tab) => Tab(text: tab)).toList(),
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
            // chapters[notes]
            CourseChaptersScreen(
              profileData: widget.profileData,
              selectedSemester: widget.selectedSemester,
              selectedBatch: widget.selectedBatch,
              courseType: kCourseType[0],
              courseModel: widget.courseModel,
              batches: widget.batches,
            ),

            // video list
            CourseVideos(
              profileData: widget.profileData,
              selectedYear: widget.selectedSemester,
              selectedBatch: widget.selectedBatch,
              courseModel: widget.courseModel,
              batches: widget.batches,
            ),

            // books
            CourseTypesDetails(
              profileData: widget.profileData,
              selectedSemester: widget.selectedSemester,
              selectedBatch: widget.selectedBatch,
              courseType: kCourseType[2],
              courseModel: widget.courseModel,
              batches: widget.batches,
            ),

            // questions
            CourseTypesDetails(
              profileData: widget.profileData,
              selectedSemester: widget.selectedSemester,
              selectedBatch: widget.selectedBatch,
              courseType: kCourseType[3],
              courseModel: widget.courseModel,
              batches: widget.batches,
            ),

            // syllabus
            CourseTypesDetails(
              profileData: widget.profileData,
              selectedSemester: widget.selectedSemester,
              selectedBatch: widget.selectedBatch,
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
