import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.university,
    required this.department,
    required this.batch,
    required this.id,
    required this.session,
    required this.name,
    required this.email,
    required this.phone,
    required this.blood,
    required this.hall,
    required this.status,
    required this.imageUrl,
    required this.role,
    required this.uid,
    required this.deviceToken,
  });

  final String university;
  final String department;
  final String batch;
  final String id;
  final String session;
  final String name;
  final String email;
  final String phone;
  final String blood;
  final String hall;
  final String status;
  final String imageUrl;
  final Map<dynamic, dynamic> role;
  final String uid;
  final String deviceToken;

  // get
  UserModel.fromJson(DocumentSnapshot json)
      : this(
          university: json['university']! as String,
          department: json['department']! as String,
          batch: json['batch']! as String,
          id: json['id']! as String,
          session: json['session']! as String,
          name: json['name']! as String,
          email: json['email']! as String,
          phone: json['phone']! as String,
          blood: json['blood']! as String,
          hall: json['hall']! as String,
          status: json['status']! as String,
          imageUrl: json['imageUrl']! as String,
          role: (json['role']!) as Map,
          uid: json['uid']! as String,
          deviceToken: json['deviceToken']! as String,
        );

  // up
  Map<String, dynamic> toJson() => {
        'university': university,
        'department': department,
        'batch': batch,
        'id': id,
        'session': session,
        'name': name,
        'email': email,
        'phone': phone,
        'blood': blood,
        'hall': hall,
        'status': status,
        'imageUrl': imageUrl,
        'role': role,
        'uid': uid,
        'deviceToken': deviceToken,
      };
}
