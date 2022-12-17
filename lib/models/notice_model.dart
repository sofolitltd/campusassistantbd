import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  final String uploader;
  final String message;
  final List<String> imageUrl;
  final List<String> batch;
  final List<String> seen;
  final String time;

  NoticeModel({
    required this.uploader,
    required this.batch,
    required this.message,
    required this.imageUrl,
    required this.seen,
    required this.time,
  });

  // fetch
  NoticeModel.fromJson(DocumentSnapshot json)
      : this(
          uploader: json['uploader']! as String,
          message: json['message']! as String,
          imageUrl: (json['imageUrl']! as List).cast<String>(),
          batch: (json['batch']! as List).cast<String>(),
          seen: (json['seen']! as List).cast<String>(),
          time: json['time']! as String,
        );

  // upload
  Map<String, dynamic> toJson() {
    return {
      'uploader': uploader,
      'message': message,
      'imageUrl': imageUrl,
      'batch': batch,
      'seen': seen,
      'time': time,
    };
  }
}
