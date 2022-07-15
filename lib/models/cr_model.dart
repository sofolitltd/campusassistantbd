import 'package:cloud_firestore/cloud_firestore.dart';

class CrModel {
  final String name;
  final String email;
  final String phone;
  final String batch;
  final String year;
  final String fb;
  final String imageUrl;

  CrModel({
    required this.name,
    required this.batch,
    required this.year,
    required this.email,
    required this.phone,
    required this.fb,
    required this.imageUrl,
  });

  //fetch
  CrModel.fromJson(DocumentSnapshot json)
      : this(
          name: json['name']! as String,
          batch: json['batch']! as String,
          year: json['year']! as String,
          email: json['email']! as String,
          phone: json['phone']! as String,
          fb: json['fb']! as String,
          imageUrl: json['imageUrl']! as String,
        );

  // upload
  Map<String, dynamic> toJson() => {
        'name': name,
        'batch': batch,
        'year': year,
        'email': email,
        'phone': phone,
        'fb': fb,
        'imageUrl': imageUrl,
      };
}
