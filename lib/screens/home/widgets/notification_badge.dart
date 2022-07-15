import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        }

        var data = snapshot.data;
        var userModel = UserModel.fromJson(data!);

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc(userModel.university)
              .collection('Departments')
              .doc(userModel.department)
              .collection('Notifications')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('');
            }

            var totalMessage = snapshot.data!.docs.length;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Universities')
                  .doc(userModel.university)
                  .collection('Departments')
                  .doc(userModel.department)
                  .collection('Notifications')
                  .where('seen', arrayContains: userModel.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('');
                }

                var seenMessage = snapshot.data!.size;
                var unseenMessage = (totalMessage - seenMessage);
                return unseenMessage != 0
                    ? Container(
                        constraints:
                            const BoxConstraints(minWidth: 20, minHeight: 20),

                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            border: Border.all(color: Colors.white, width: 1)),
                        child: Text(
                          unseenMessage.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // child: Text('10'),
                      )
                    : const Text('');
              },
            );
          },
        );
      },
    );
  }
}
