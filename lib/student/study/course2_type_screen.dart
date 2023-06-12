import 'package:flutter/material.dart';

import '/models/course_model.dart';
import '/models/user_model.dart';
import '../../utils/constants.dart';
import 'course3_notes_chapters.dart';
import 'course5_types_details.dart';
import 'course7_videos.dart';
import 'widgets/bookmark_counter.dart';

class CourseTypeScreen extends StatefulWidget {
  const CourseTypeScreen({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    required this.courseModel,
    required this.selectedSession,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final CourseModel courseModel;
  final String selectedSession;

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

          // bookmark
          actions: [
            BookmarkCounter(
              userModel: widget.userModel,
            ),
          ],
        ),

        //
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              // chapter list
              CourseNotesChapters(
                userModel: widget.userModel,
                selectedYear: widget.selectedYear,
                id: widget.id,
                courseType: kCourseType[0],
                courseModel: widget.courseModel,
                selectedSession: widget.selectedSession,
              ),

              //video list
              CourseVideos(
                userModel: widget.userModel,
                selectedYear: widget.selectedYear,
                id: widget.id,
                // courseChapterModel: courseChapterModel,
                courseModel: widget.courseModel,
              ),

              //
              CourseTypesDetails(
                userModel: widget.userModel,
                selectedYear: widget.selectedYear,
                id: widget.id,
                courseType: kCourseType[2],
                courseModel: widget.courseModel,
              ),
              CourseTypesDetails(
                userModel: widget.userModel,
                selectedYear: widget.selectedYear,
                id: widget.id,
                courseType: kCourseType[3],
                courseModel: widget.courseModel,
              ),
              CourseTypesDetails(
                userModel: widget.userModel,
                selectedYear: widget.selectedYear,
                id: widget.id,
                courseType: kCourseType[4],
                courseModel: widget.courseModel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
