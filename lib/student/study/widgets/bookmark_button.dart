import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/content_model.dart';
import '/models/user_model.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({
    Key? key,
    required this.userModel,
    required this.courseContentModel,
  }) : super(key: key);

  final UserModel userModel;
  final ContentModel courseContentModel;

  @override
  Widget build(BuildContext context) {
    //todo: fix ref
    var ref = FirebaseFirestore.instance
        .collection("Universities")
        .doc(userModel.university)
        .collection('Departments')
        .doc(userModel.department)
        .collection('Bookmarks')
        .doc(userModel.email)
        .collection('Contents');

    //
    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: 40,
            width: 40,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border_outlined,
                )),
          );
        }

        var id = '';
        for (var element in snapshot.data!.docs) {
          id = element.id;
          if (id == courseContentModel.contentId) {
            return SizedBox(
              height: 40,
              width: 40,
              child: IconButton(
                  onPressed: () async {
                    //todo: fix ref
                    await ref
                        .doc(courseContentModel.contentId)
                        .delete()
                        .then((value) {
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(msg: 'Remove Bookmark');
                    });
                  },
                  icon: const Icon(Icons.favorite_outlined, color: Colors.red)),
            );
          }
        }

        //
        return SizedBox(
          height: 40,
          width: 40,
          child: IconButton(
              onPressed: () async {
                ref.doc(courseContentModel.contentId).set({
                  'userEmail': userModel.email,
                  'courseType': courseContentModel.contentType,
                  'contentId': courseContentModel.contentId,
                }).then((value) {
                  //
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(msg: 'Add Bookmark');
                });
              },
              icon: const Icon(
                Icons.favorite_border_outlined,
              )),
        );
      },
    );
  }
}
