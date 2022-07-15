import 'package:cloud_firestore/cloud_firestore.dart';

class ContentModel {
  final String contentId;
  final String courseCode;
  final String contentType;
  final int lessonNo;
  final String status;
  final List<String> sessionList;
  final String contentTitle;
  final String contentSubtitle;
  final String contentSubtitleType;
  final String uploadDate;
  final String fileUrl;
  final String imageUrl;
  final String uploader;

  ContentModel({
    required this.contentId,
    required this.courseCode,
    required this.contentType,
    required this.lessonNo,
    required this.status,
    required this.sessionList,
    required this.contentTitle,
    required this.contentSubtitle,
    required this.contentSubtitleType,
    required this.uploadDate,
    required this.fileUrl,
    required this.imageUrl,
    required this.uploader,
  });

  // fetch
  ContentModel.fromJson(DocumentSnapshot json)
      : this(
          contentId: json['contentId']! as String,
          courseCode: json['courseCode']! as String,
          contentType: json['contentType']! as String,
          lessonNo: json['lessonNo']! as int,
          status: json['status']! as String,
          sessionList: (json['sessionList']! as List).cast<String>(),
          contentTitle: json['contentTitle']! as String,
          contentSubtitle: json['contentSubtitle']! as String,
          contentSubtitleType: json['contentSubtitleType']! as String,
          uploadDate: json['uploadDate']! as String,
          fileUrl: json['fileUrl']! as String,
          imageUrl: json['imageUrl']! as String,
          uploader: json['uploader']! as String,
        );

  // upload
  Map<String, dynamic> toJson() {
    return {
      'contentId': contentId,
      'courseCode': courseCode,
      'contentType': contentType,
      'lessonNo': lessonNo,
      'status': status,
      'sessionList': sessionList,
      'contentTitle': contentTitle,
      'contentSubtitle': contentSubtitle,
      'contentSubtitleType': contentSubtitleType,
      'uploadDate': uploadDate,
      'fileUrl': fileUrl,
      'imageUrl': imageUrl,
      'uploader': uploader,
    };
  }
}
