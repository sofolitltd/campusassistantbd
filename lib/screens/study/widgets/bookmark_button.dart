import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/content_model.dart';
import '/models/profile_data.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({
    Key? key,
    required this.profileData,
    required this.contentModel,
  }) : super(key: key);

  final ProfileData profileData;
  final ContentModel contentModel;

  @override
  Widget build(BuildContext context) {
    //
    var ref = FirebaseFirestore.instance
        .collection("Universities")
        .doc(profileData.university)
        .collection('Departments')
        .doc(profileData.department)
        .collection('bookmarks')
        .doc(profileData.email)
        .collection('contents');

    //
    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: 40,
            width: 40,
            child: IconButton(
                tooltip: 'Bookmark file',
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border_outlined,
                )),
          );
        }

        var id = '';
        for (var element in snapshot.data!.docs) {
          id = element.id;
          if (id == contentModel.contentId) {
            return SizedBox(
              height: 40,
              width: 40,
              child: IconButton(
                  tooltip: 'Bookmark file',
                  onPressed: () async {
                    //todo: fix ref
                    await ref
                        .doc(contentModel.contentId)
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
            tooltip: 'Bookmark file',
            onPressed: () async {
              ref.doc(contentModel.contentId).set({
                'userEmail': profileData.email,
                'courseType': contentModel.contentType.toLowerCase(),
                'contentId': contentModel.contentId,
              }).then((value) {
                //
                Fluttertoast.cancel();
                Fluttertoast.showToast(msg: 'Add Bookmark');
              });
            },
            icon: const Icon(
              Icons.favorite_border_outlined,
            ),
          ),
        );
      },
    );
  }
}
