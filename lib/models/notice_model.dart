import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  final String uploaderName;
  final String uploaderImage;
  final String message;
  final String time;
  final List<String> batch;
  final List<String> seen;

  NoticeModel({
    required this.uploaderName,
    required this.uploaderImage,
    required this.batch,
    required this.message,
    required this.time,
    required this.seen,
  });

  // fetch
  NoticeModel.fromJson(DocumentSnapshot json)
      : this(
          uploaderName: json['uploaderName']! as String,
          uploaderImage: json['uploaderImage']! as String,
          message: json['message']! as String,
          time: json['time']! as String,
          batch: (json['batch']! as List).cast<String>(),
          seen: (json['seen']! as List).cast<String>(),
        );

  // upload
  Map<String, dynamic> toJson() {
    return {
      'uploaderName': uploaderName,
      'uploaderImage': uploaderImage,
      'batch': batch,
      'message': message,
      'time': time,
      'seen': seen,
    };
  }
}
