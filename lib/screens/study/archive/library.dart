import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '/models/content_model.dart';
import '/models/profile_data.dart';
import '/screens/study/widgets/bookmark_counter.dart';
import '/screens/study/widgets/content_card.dart';

class Library extends StatelessWidget {
  const Library({super.key, required this.profileData, required this.batches});
  final ProfileData profileData;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    var fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        centerTitle: true,
        actions: [
          BookmarkCounter(
            profileData: profileData,
            batches: [],
          ),
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
                batches: batches,
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
