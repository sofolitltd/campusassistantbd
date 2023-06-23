import 'package:campusassistant/admin/sessions_screen.dart';
import 'package:campusassistant/screens/profile/moderator/batch_all_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/admin/batches_screen.dart';
import '/models/profile_data.dart';

class ModeratorDashboard extends StatelessWidget {
  const ModeratorDashboard({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Moderator Dashboard'),
      ),

      //
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width * .19
              : 16,
          vertical: 16,
        ),
        child: Column(
          children: [
            //
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 4 / 3,
              children: [
                GridViewCard(
                  title: 'Batches',
                  university: profileData.university,
                  department: profileData.department,
                ),
                GridViewCard(
                  title: 'Sessions',
                  university: profileData.university,
                  department: profileData.department,
                ),
              ],
            ),

            const SizedBox(height: 16),

            //users
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BatchAllUser(
                    university: profileData.university,
                    department: profileData.department,
                  );
                }));
              },
              child: Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("All Users".toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w300)),

                    //
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('university',
                                isEqualTo: profileData.university)
                            .where('department',
                                isEqualTo: profileData.department)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          }
                          var docs = snapshot.data;

                          return Text(
                            '${docs!.size}',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
class GridViewCard extends StatelessWidget {
  const GridViewCard({
    super.key,
    required this.title,
    required this.university,
    required this.department,
  });

  final String title;
  final String university;
  final String department;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          switch (title) {
            case 'Sessions':
              return SessionsScreen(
                  university: university, department: department);
              break;
            // case 'Sessions':
          }
          return BatchesScreen(university: university, department: department);
        }));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w300)),

            //
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Universities')
                    .doc(university)
                    .collection('Departments')
                    .doc(department)
                    .collection(title.toLowerCase())
                    // .orderBy('name', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  var docs = snapshot.data;

                  return Text(
                    '${docs!.size}',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
