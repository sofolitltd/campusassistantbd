import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModelNew {
  final String courseYear;
  final String courseCategory;
  final String courseCode;
  final String courseTitle;
  final String courseCredits;
  final String courseMarks;
  final String image;
  final List<dynamic> batches;

  CourseModelNew({
    required this.courseYear,
    required this.courseCategory,
    required this.courseCode,
    required this.courseTitle,
    required this.courseCredits,
    required this.courseMarks,
    required this.batches,
    required this.image,
  });

  // fetch
  CourseModelNew.fromJson(DocumentSnapshot json)
      : this(
          courseYear: json['courseYear']! as String,
          courseCategory: json['courseCategory']! as String,
          courseCode: json['courseCode']! as String,
          courseTitle: json['courseTitle']! as String,
          courseCredits: json['courseCredits']! as String,
          courseMarks: json['courseMarks']! as String,
          image: json['image']! as String,
          batches: (json['batches']! as List).cast<String>(),
        );

  // upload
  Map<String, dynamic> toJson() {
    return {
      'courseYear': courseYear,
      'courseCategory': courseCategory,
      'courseCode': courseCode,
      'courseTitle': courseTitle,
      'courseCredits': courseCredits,
      'courseMarks': courseMarks,
      'image': image,
      'batches': batches,
    };
  }
}
