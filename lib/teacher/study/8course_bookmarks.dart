import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/content_model.dart';
import '../../models/profile_data.dart';
import 'widgets/content_card.dart';
import 'widgets/content_card_web.dart';

class CourseBookMarks extends StatelessWidget {
  const CourseBookMarks({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  final ProfileData profileData;

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
            .collection('Bookmarks')
            .doc(profileData.email)
            .collection('Contents')
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
                    .collection(courseType)
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

                  // for web browser
                  if (kIsWeb) {
                    return ContentCardWeb(
                      profileData: profileData,
                      courseContentModel: courseContentModel,
                    );
                  }

                  //for mobile
                  return ContentCard(
                    profileData: profileData,
                    contentModel: courseContentModel,
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
