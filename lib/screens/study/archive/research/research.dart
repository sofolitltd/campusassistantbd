import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '/models/profile_data.dart';
import '/screens/study/archive/research/research_add.dart';

class Research extends StatelessWidget {
  const Research({super.key, required this.profileData, required this.batches});

  final ProfileData profileData;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddResearch(
                      university: profileData.university,
                      department: profileData.department,
                      profileData: profileData)));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Research'),
        centerTitle: true,
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('university', isEqualTo: profileData.university)
              // .collection('Universities')
              // .doc(profileData.university)
              // .collection('Departments')
              // .doc(profileData.department)
              // .collection('students')
              // .doc('batches')
              // .doc('Archive')
              // .collection('Research')
              // .orderBy('courseCode')
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

            if (snapshot.data!.docs == 0) {
              return const Center(child: Text('No data Found!'));
            }

            var data = snapshot.data!.docs;
            //
            List<String> listItem = [];
            for (var item in data) {
              String name = item.get('name');
              listItem.add(name);
            }

            //
            return Autocomplete(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                List<String> words =
                    textEditingValue.text.toLowerCase().split(' ');
                return listItem.where((String item) {
                  // Check if all words are contained in the item
                  return words
                      .every((word) => item.toLowerCase().contains(word));
                });
              },
              onSelected: (String item) {
                print(item);
              },
            );
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              // itemCount: data.length,
              itemCount: 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                //model
                // ContentModel courseContentModel =
                //     ContentModel.fromJson(data[index]);

                //
                // return ContentCard(
                //   selectedSemester: 'Research',
                //   selectedBatch: '',
                //   profileData: profileData,
                //   contentModel: courseContentModel,
                //   batches: batches,
                // );
              },
            );
          }),
    );
  }
}
