import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/profile_data.dart';
import '/utils/constants.dart';
import 'cr_add.dart';
import 'cr_card.dart';

class Cr extends StatelessWidget {
  const Cr({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(profileData.university)
        .collection('Departments')
        .doc(profileData.department)
        .collection('Cr');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Representative'),
        centerTitle: true,
      ),
      floatingActionButton: profileData.information.status!.moderator!
          ? FloatingActionButton(
              onPressed: () async {
                List<String> batchList = [];
                await FirebaseFirestore.instance
                    .collection('Universities')
                    .doc(profileData.university)
                    .collection('Departments')
                    .doc(profileData.department)
                    .collection('batches')
                    .orderBy('name')
                    .get()
                    .then(
                  (QuerySnapshot snapshot) {
                    for (var batch in snapshot.docs) {
                      batchList.add(batch.get('name'));
                    }
                  },
                ).then(
                  (value) {
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddCr(
                          profileData: profileData,
                          batchList: batchList,
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      //
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width * .2
              : 16,
          vertical: 16,
        ),
        children: kYearList
            .map(
              (year) => CrCard(
                profileData: profileData,
                year: year,
                ref: ref,
              ),
            )
            .toList(),
      ),
    );
  }
}
