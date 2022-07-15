import 'package:cloud_firestore/cloud_firestore.dart';

class ChapterModel {
  final String courseCode;
  final int chapterNo;
  final String chapterTitle;
  final List<dynamic> sessionList;

  ChapterModel({
    required this.courseCode,
    required this.chapterNo,
    required this.chapterTitle,
    required this.sessionList,
  });

  // fetch
  ChapterModel.fromJson(DocumentSnapshot json)
      : this(
          courseCode: json['courseCode']! as String,
          chapterNo: json['chapterNo']! as int,
          chapterTitle: json['chapterTitle']! as String,
          sessionList: (json['sessionList']! as List).cast<String>(),
        );

  // upload
  Map<String, dynamic> toJson() {
    return {
      'courseCode': courseCode,
      'chapterNo': chapterNo,
      'chapterTitle': chapterTitle,
      'sessionList': sessionList,
    };
  }
}
