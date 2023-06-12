import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';
import 'syllabus_card.dart';
import 'syllabus_card_web.dart';

class Syllabus extends StatelessWidget {
  static const routeName = '/syllabus';

  const Syllabus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Full Syllabus'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(userModel.university)
            .collection('Departments')
            .doc(userModel.department)
            .collection('SyllabusFull')
            .orderBy('contentTitle', descending: true)
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
          return GridView.builder(
            itemCount: data.length,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 12,
              vertical: 12,
            ),
            itemBuilder: (context, index) {
              var contentData = data[index];

              // for web browser
              if (kIsWeb) {
                return SyllabusCardWeb(contentData: contentData);
              }

              //for mobile
              return SyllabusCard(contentData: contentData);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 16 / 9,
            ),
          );
        },
      ),
    );
  }
}
