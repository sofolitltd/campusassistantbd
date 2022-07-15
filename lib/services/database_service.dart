import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chapter_model.dart';
import '../models/content_model.dart';
import '../models/course_model.dart';

class DatabaseService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static var refUniversities =
      FirebaseFirestore.instance.collection('Universities');

  //
  static addCourse({
    required university,
    required department,
    required String year,
    required CourseModel courseModel,
  }) async {
    //
    await refUniversities
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection('Courses')
        .doc()
        .set(courseModel.toJson());
  }

  //
  static addCourseChapter({
    required university,
    required department,
    required year,
    required String id,
    required ChapterModel courseLessonModel,
  }) {
    //
    refUniversities
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection('Chapters')
        .doc()
        .set(courseLessonModel.toJson());
  }

  //
  static addCourseContent({
    required university,
    required department,
    required year,
    required String contentId,
    required String courseType,
    required ContentModel courseContentModel,
  }) async {
    //
    var ref = refUniversities
        .doc(university)
        .collection('Departments')
        .doc(department);

    //
    await ref
        .collection(courseType)
        .doc(contentId)
        .set(courseContentModel.toJson());
  }

  //
  static deleteCourseContent({
    required university,
    required department,
    required year,
    required String id,
    required String courseType,
    required String contentId,
  }) async {
    //
    var ref = refUniversities
        .doc(university)
        .collection('Departments')
        .doc(department);

    //
    await ref.collection(courseType).doc(contentId).delete();
  }
}
