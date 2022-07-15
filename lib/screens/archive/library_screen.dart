import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/models/content_model.dart';
import '/models/user_model.dart';
import '/services/database_service.dart';
import '../study/widgets/content_card.dart';
import '../study/widgets/content_card_web.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  UserModel? userModel;

  //
  getUser() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUser!.email)
        .get()
        .then((value) {
      for (var element in value.docs) {
        userModel = UserModel.fromJson(element);
      }
      setState(() {});
    });
  }

  //
  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      //
      body: (userModel == null)
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: DatabaseService.refUniversities
                  .doc(userModel!.university)
                  .collection('Departments')
                  .doc(userModel!.department)
                  .collection('Books')
                  .orderBy('courseCode')
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
                  itemBuilder: (context, index) {
                    //model
                    ContentModel courseContentModel =
                        ContentModel.fromJson(data[index]);

                    var contentData = data[index];

                    // for web browser
                    if (kIsWeb) {
                      return ContentCardWeb(
                        userModel: userModel!,
                        courseContentModel: courseContentModel,
                      );
                    }

                    //for mobile
                    return ContentCard(
                      userModel: userModel!,
                      courseContentModel: courseContentModel,
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
