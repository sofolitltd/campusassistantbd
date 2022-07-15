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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // user name
          // StreamBuilder<DocumentSnapshot>(
          //   stream: ref.collection('Users').doc(currentUser).snapshots(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasError) {
          //       return const Center(child: Text('Something went wrong'));
          //     }
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       // return Center(child: CircularProgressIndicator());
          //       return const SizedBox(
          //           height: 32, child: Center(child: Text('')));
          //     }
          //
          //     //
          //     return SizedBox(
          //       height: 32,
          //       child: Text(
          //         snapshot.data!.get('name').toUpperCase(),
          //         style: const TextStyle(
          //           fontSize: 22,
          //           fontWeight: FontWeight.bold,
          //         ),
          //         overflow: TextOverflow.ellipsis,
          //       ),
          //     );
          //   },
          // ),

          const Text(
            'Welcome back',
            style: TextStyle(fontSize: 16),
          ),

          // welcome
          Text(
            userName.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
