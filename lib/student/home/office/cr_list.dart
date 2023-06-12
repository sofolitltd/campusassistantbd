import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';
import '/utils/constants.dart';
import 'add_cr.dart';
import 'widgets/cr_list_card.dart';

class CrList extends StatelessWidget {
  const CrList({
    Key? key,
    required this.userModel,
  }) : super(key: key);
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(userModel.university)
        .collection('Departments')
        .doc(userModel.department)
        .collection('Cr');

    return Scaffold(
      floatingActionButton: userModel.role[UserRole.admin.name]
          ? FloatingActionButton(
              onPressed: () async {
                List<String> batchList = [];
                await FirebaseFirestore.instance
                    .collection('Universities')
                    .doc(userModel.university)
                    .collection('Departments')
                    .doc(userModel.department)
                    .collection('Batches')
                    .orderBy('name')
                    .get()
                    .then(
                  (QuerySnapshot snapshot) {
                    for (var batch in snapshot.docs) {
                      batchList.add(batch.get('name'));
                    }
                  },
                ).then((value) {
                  //
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddCr(
                              userModel: userModel, batchList: batchList)));
                });
              },
              child: const Icon(Icons.add),
            )
          : null,

      //
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .2
                : 16,
            vertical: 16),
        children: kYearList
            .map((year) =>
                CrListCard(userModel: userModel, year: year, ref: ref))
            .toList(),
      ),
    );
  }
}
