import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/profile_data.dart';
import 'club_details.dart';

class Clubs extends StatelessWidget {
  static const routeName = '/clubs';

  const Clubs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileData? profileData = Get.arguments['profileData'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Clubs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(profileData!.university)
            .collection('Departments')
            .doc(profileData.department)
            .collection('Clubs')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No data Found!'));
          }

          var data = snapshot.data!.docs;

          //
          return ListView.separated(
            itemCount: data.length,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 12,
              vertical: 12,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              //for mobile
              return ClubsCard(data: data[index]);
            },
          );
        },
      ),
    );
  }
}

//
class ClubsCard extends StatelessWidget {
  const ClubsCard({Key? key, required this.data}) : super(key: key);
  final QueryDocumentSnapshot data;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Get.to(ClubDetails(data: data));
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 25,
              ),

              const SizedBox(width: 10),

              //
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //
                    Text(
                      data.get('name'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 8),
                    //
                    Text(
                      'Established: ${data.get('established')}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
