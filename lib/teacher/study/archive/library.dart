import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '/models/content_model.dart';
import '/models/profile_data.dart';
import '/teacher/study/widgets/bookmark_counter.dart';
import '/teacher/study/widgets/content_card.dart';

class Library extends StatelessWidget {
  const Library({Key? key}) : super(key: key);
  static const routeName = '/library';

  @override
  Widget build(BuildContext context) {
    var fullWidth = MediaQuery.of(context).size.width;
    ProfileData profileData = Get.arguments['profileData'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        centerTitle: true,
        actions: [
          BookmarkCounter(profileData: profileData),
          const SizedBox(width: 4),
        ],
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(profileData.university)
            .collection('Departments')
            .doc(profileData.department)
            .collection('books')
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
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 12,
              vertical: 12,
            ),
            itemBuilder: (context, index) {
              //model
              ContentModel courseContentModel =
                  ContentModel.fromJson(data[index]);

              var contentData = data[index];

              // // for web browser
              // if (kIsWeb) {
              //   return ContentCardWeb(
              //     userModel: userModel!,
              //     courseContentModel: courseContentModel,
              //   );
              // }

              // for mobile
              return ContentCard(
                profileData: profileData,
                contentModel: courseContentModel,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 12);
            },
          );
        },
      ),
    );
  }
}
