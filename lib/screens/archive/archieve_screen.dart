import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/screens/archive/library_screen.dart';
import '/screens/archive/research_screen.dart';
import '/screens/study/widgets/bookmark_counter.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  UserModel? userModel;

  //
  getUser() async {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value);

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
    return DefaultTabController(
      length: kArchive.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Archive'),
          bottom: TabBar(
              isScrollable:
                  MediaQuery.of(context).size.width > 1000 ? true : false,
              tabs: kArchive.map((item) => Tab(text: item)).toList()),

          //
          actions: [
            if (userModel != null) BookmarkCounter(userModel: userModel!),
            const SizedBox(width: 8),
          ],
        ),
        body: const TabBarView(
          children: [
            LibraryScreen(),
            ResearchScreen(),
          ],
        ),
      ),
    );
  }
}
