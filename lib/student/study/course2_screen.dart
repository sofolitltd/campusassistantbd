import 'package:flutter/material.dart';

import '/models/user_model.dart';
import '/utils/constants.dart';
import 'upload/course_add.dart';
import 'widgets/course_list.dart';

class CourseScreen2 extends StatefulWidget {
  static const routeName = 'course2_screen';
  const CourseScreen2({
    Key? key,
    required this.university,
    required this.department,
    required this.selectedYear,
    required this.userModel,
    required this.selectedSession,
  }) : super(key: key);

  final String university;
  final String department;
  final String selectedYear;
  final UserModel userModel;
  final String selectedSession;

  @override
  State<CourseScreen2> createState() => _CourseScreen2State();
}

class _CourseScreen2State extends State<CourseScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.selectedYear} - Courses'),
      ),

      // add course
      floatingActionButton: (widget.userModel.role[UserRole.admin.name])
          ? FloatingActionButton(
              onPressed: () async {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCourse(
                      university: widget.university,
                      department: widget.department,
                      selectedYear: widget.selectedYear,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      // course list
      body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 1000
                ? MediaQuery.of(context).size.width * .2
                : 8,
          ),
          children: kCourseCategory
              .map(
                (courseCategory) => CourseList(
                  courseCategory: courseCategory,
                  userModel: widget.userModel,
                  selectedYear: widget.selectedYear,
                  selectedSession: widget.selectedSession,
                ),
              )
              .toList()),
    );
  }
}
