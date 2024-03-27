import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/content_model.dart';
import '/models/profile_data.dart';
import 'widgets/content_card.dart';

class CourseBookMarks extends StatelessWidget {
  const CourseBookMarks({
    super.key,
    required this.profileData,
    required this.batches,
  });

  final ProfileData profileData;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: const Text('Bookmarks'),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Universities")
            .doc(profileData.university)
            .collection('Departments')
            .doc(profileData.department)
            .collection('bookmarks')
            .doc(profileData.email)
            .collection('contents')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('something wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No Bookmarks Found!'));
          }

          var data = snapshot.data!.docs;

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 12),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 12,
              vertical: 12,
            ),
            itemBuilder: (context, index) {
              var contentData = data[index];
              var courseType = data[index].get('courseType');

              //
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Universities")
                    .doc(profileData.university)
                    .collection('Departments')
                    .doc(profileData.department)
                    .collection(courseType.toString().toLowerCase())
                    .doc(contentData.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('something wrong'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.data!.exists) {
                    return const Center(child: Text('No Bookmarks Found!'));
                  }

                  var data = snapshot.data!;
                  // model
                  ContentModel courseContentModel = ContentModel.fromJson(data);

                  //for mobile
                  return ContentCard(
                    selectedSemester: 'Bookmarks',
                    selectedBatch: '',
                    profileData: profileData,
                    contentModel: courseContentModel,
                    batches: batches,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
