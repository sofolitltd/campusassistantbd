import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String courseYear;
  final String courseCategory;
  final String courseCode;
  final String courseTitle;
  final String courseCredits;
  final String courseMarks;
  final List<String> sessionList;
  final String imageUrl;

  CourseModel({
    required this.courseYear,
    required this.courseCategory,
    required this.courseCode,
    required this.courseTitle,
    required this.courseCredits,
    required this.courseMarks,
    required this.sessionList,
    required this.imageUrl,
  });

  // fetch
  CourseModel.fromJson(DocumentSnapshot json)
      : this(
          courseYear: json['courseYear']! as String,
          courseCategory: json['courseCategory']! as String,
          courseCode: json['courseCode']! as String,
          courseTitle: json['courseTitle']! as String,
          courseCredits: json['courseCredits']! as String,
          courseMarks: json['courseMarks']! as String,
          sessionList: (json['sessionList']! as List).cast<String>(),
          imageUrl: json['imageUrl']! as String,
        );

  // upload
  Map<String, dynamic> toJson() {
    return {
      'courseYear': courseYear,
      'sessionList': sessionList,
      'courseCategory': courseCategory,
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'courseCredits': courseCredits,
      'courseMarks': courseMarks,
      'imageUrl': imageUrl,
    };
  }
}
