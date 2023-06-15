import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/profile_data.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({super.key, required this.profileData});
  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(profileData.university)
        .collection('Departments')
        .doc(profileData.department)
        .collection('notices');

    return StreamBuilder<QuerySnapshot>(
      stream: ref
          .where('batch', arrayContains: profileData.information.batch)
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
          stream: ref.where('seen', arrayContains: profileData.uid).snapshots(),
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
                        border: Border.all(color: Colors.white, width: .5)),
                    child: Text(
                      unseenMessage.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1,
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
  }
}
