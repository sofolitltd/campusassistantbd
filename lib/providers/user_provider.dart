import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../models/user_model.dart';

class UserProvider with ChangeNotifier {


  //
  getUser(UserModel userModel) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUser!.email)
        .get()
        .then(
      (value) {
        for (var element in value.docs) {
          userModel = UserModel.fromJson(element);
        }
        notifyListeners();
      },
    );
    return userModel;
  }
}
