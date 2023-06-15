import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '/models/content_model.dart';
import '/models/profile_data.dart';
import '../widgets/content_card.dart';

class Research extends StatelessWidget {
  const Research({super.key, required this.profileData, required this.batches});
  final ProfileData profileData;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Research'),
        centerTitle: true,
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc(profileData.university)
              .collection('Departments')
              .doc(profileData.department)
              .collection('Study')
              .doc('Archive')
              .collection('Research')
              .orderBy('courseCode')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitFoldingCube(
                  size: 64,
                  color: Colors.deepOrange.shade100,
                ),
              );
            }

            if (snapshot.data!.size == 0) {
              return const Center(child: Text('No data Found!'));
            }

            var data = snapshot.data!.docs;

            //
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                //model
                ContentModel courseContentModel =
                    ContentModel.fromJson(data[index]);

                var contentData = data[index];
                //

                return ContentCard(
                  selectedYear: 'Research',
                  profileData: profileData,
                  contentModel: courseContentModel,
                  batches: batches,
                );
              },
            );
          }),
    );
  }
}
