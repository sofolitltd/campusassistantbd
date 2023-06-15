import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String name;
  final String id;
  final String session;
  final String phone;
  final String email;
  final String hall;
  final String blood;
  final String imageUrl;
  final String token;
  final int orderBy;

  StudentModel({
    required this.name,
    required this.id,
    required this.session,
    required this.phone,
    required this.email,
    required this.hall,
    required this.blood,
    required this.imageUrl,
    required this.token,
    required this.orderBy,
  });

  //fetch
  StudentModel.fromJson(DocumentSnapshot json)
      : this(
          name: json['name']! as String,
          id: json['id']! as String,
          session: json['session']! as String,
          hall: json['hall']! as String,
          blood: json['blood']! as String,
          phone: json['phone']! as String,
          email: json['email']! as String,
          imageUrl: json['imageUrl']! as String,
          token: json['token']! as String,
          orderBy: json['orderBy']! as int,
        );

  //upload
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'session': session,
      'hall': hall,
      'blood': blood,
      'phone': phone,
      'email': email,
      'imageUrl': imageUrl,
      'token': token,
      'orderBy': orderBy,
    };
  }
}
