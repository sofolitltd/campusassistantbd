import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final ref = FirebaseFirestore.instance;
final currentUser = FirebaseAuth.instance.currentUser!.uid;

class Header extends StatelessWidget {
  const Header({Key? key, required this.userName}) : super(key: key);

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: MediaQuery.of(context).size.width > 800
            ? MediaQuery.of(context).size.width * .2
            : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //welcome
          Text(
            'Welcome back ,'.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),

          const SizedBox(height: 4),
          // user name
          Text(
            userName.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                  letterSpacing: .5,
                ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
