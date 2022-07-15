import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModel {
  final String id;
  final bool present;
  final bool chairman;
  final int serial;
  final String name;
  final String post;
  final String phd;
  final String mobile;
  final String email;
  final String imageUrl;
  final String interests;
  final String publications;

  TeacherModel({
    required this.id,
    required this.serial,
    required this.present,
    required this.chairman,
    required this.name,
    required this.post,
    required this.phd,
    required this.mobile,
    required this.email,
    required this.interests,
    required this.publications,
    required this.imageUrl,
  });

  // fetch
  TeacherModel.formJson(DocumentSnapshot json)
      : this(
          serial: json['serial']! as int,
          present: json['present']! as bool,
          chairman: json['chairman']! as bool,
          id: json['id']! as String,
          name: json['name']! as String,
          post: json['post']! as String,
          phd: json['phd']! as String,
          mobile: json['mobile']! as String,
          email: json['email']! as String,
          interests: json['interests']! as String,
          publications: json['publications']! as String,
          imageUrl: json['imageUrl']! as String,
        );

  //up
  Map<String, dynamic> toJson() {
    return {
      'serial': serial,
      'present': present,
      'id': id,
      'name': name,
      'post': post,
      'chairman': chairman,
      'phd': phd,
      'mobile': mobile,
      'email': email,
      'interests': interests,
      'publications': publications,
      'imageUrl': imageUrl,
    };
  }
}
