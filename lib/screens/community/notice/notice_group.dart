import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/notice_model.dart';
import '/models/profile_data.dart';
import '/screens/home/explore/student/widget/full_image.dart';
import '/widgets/headline.dart';
import 'comment_screen.dart';
import 'notice_add.dart';
import 'notice_edit.dart';
import 'notice_screen.dart';
import 'notice_screen_details.dart';

class NoticeGroup extends StatelessWidget {
  final ProfileData profileData;

  const NoticeGroup({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot? uploader;

    return Scaffold(
      floatingActionButton: (profileData.information.status!.moderator! ||
              profileData.information.status!.cr!)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoticeAdd(
                      profileData: profileData,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.message_outlined),
            )
          : null,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          //
          SliverAppBar(
            backgroundColor: Colors.pink.shade100,
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                profileData.information.batch!,
                // style: const TextStyle(color: Colors.black87),
              ),
            ),
          ),

          //
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .2
                    : 12,
                vertical: 12,
              ),
              child: Column(
                children: [
                  //
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Headline(title: 'Notices'),
                  ),

                  //
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Universities')
                        .doc(profileData.university)
                        .collection('Departments')
                        .doc(profileData.department)
                        .collection('notices')
                        .where('batch',
                            arrayContains: profileData.information.batch)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * .7,
                          child:
                              const Center(child: Text('Something went wrong')),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                            height: MediaQuery.of(context).size.height * .7,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      }

                      var data = snapshot.data!.docs;
                      return snapshot.data!.size == 0
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * .7,
                              child:
                                  const Center(child: Text('No notice found!')))
                          : ListView.separated(
                              reverse: true,
                              itemCount: data.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (BuildContext context, int index) {
                                //
                                var notice = data[index];
                                NoticeModel noticeModel =
                                    NoticeModel.fromJson(notice);

                                return GestureDetector(
                                  onTap: () {
                                    if (uploader != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullImage(
                                            title: noticeModel.message,
                                            imageUrl:
                                                noticeModel.imageUrl.first,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Card(
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(noticeModel.uploader)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(''));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const SizedBox(
                                                    height: 72,
                                                    child: Text(''));
                                              }

                                              uploader = snapshot.data;

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  // image
                                                  leading: CachedNetworkImage(
                                                    imageUrl:
                                                        uploader!.get('image'),
                                                    fadeInDuration:
                                                        const Duration(
                                                            milliseconds: 500),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        CircleAvatar(
                                                      backgroundImage:
                                                          imageProvider,
                                                      // radius: 120,
                                                    ),
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        const CircleAvatar(
                                                            // radius: 120,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/images/pp_placeholder.png')),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const CircleAvatar(
                                                            // radius: 120,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/images/pp_placeholder.png')),
                                                  ),

                                                  title: Text(
                                                    uploader!.get('name'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),

                                                  //time
                                                  subtitle: Text(
                                                    TimeAgo.timeAgoSinceDate(
                                                        noticeModel.time),
                                                  ),

                                                  //edit, delete
                                                  trailing:
                                                      (profileData
                                                                  .information
                                                                  .status!
                                                                  .moderator! ||
                                                              profileData
                                                                  .information
                                                                  .status!
                                                                  .cr!)
                                                          ? PopupMenuButton(
                                                              itemBuilder:
                                                                  (context) => [
                                                                //delete
                                                                PopupMenuItem(
                                                                  value: 1,
                                                                  onTap: () {
                                                                    //
                                                                    Future(
                                                                      () =>
                                                                          //
                                                                          Navigator
                                                                              .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              NoticeEdit(
                                                                            noticeId:
                                                                                notice.id,
                                                                            profileData:
                                                                                profileData,
                                                                            noticeModel:
                                                                                noticeModel,
                                                                            uploader:
                                                                                uploader!,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Edit'),
                                                                ),

                                                                //delete
                                                                PopupMenuItem(
                                                                    value: 2,
                                                                    onTap:
                                                                        () async {
                                                                      //
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Universities')
                                                                          .doc(profileData
                                                                              .university)
                                                                          .collection(
                                                                              'Departments')
                                                                          .doc(profileData
                                                                              .department)
                                                                          .collection(
                                                                              'notices')
                                                                          .doc(notice
                                                                              .id)
                                                                          .delete();

                                                                      //
                                                                      FirebaseStorage
                                                                          .instance
                                                                          .refFromURL(
                                                                              noticeModel.imageUrl[0])
                                                                          .delete();
                                                                    },
                                                                    child: const Text(
                                                                        'Delete')),
                                                              ],
                                                            )
                                                          : null,
                                                ),
                                              );
                                            }),
                                        //message
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: SelectableText(
                                            noticeModel.message,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),

                                        const SizedBox(height: 10),
                                        // image
                                        if (noticeModel.imageUrl[0] != '')
                                          Container(
                                            constraints: const BoxConstraints(
                                              minHeight: 250,
                                            ),
                                            color: Colors.blueGrey.shade50,
                                            child: CachedNetworkImage(
                                              // height: 300,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.contain,
                                              imageUrl: noticeModel.imageUrl[0],
                                              fadeInDuration: const Duration(
                                                  milliseconds: 500),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                  ),
                                                ),
                                              ),
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  const CupertinoActivityIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.grey.shade100,
                                                ),
                                              ),
                                            ),
                                          ),

                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Divider(height: 0),
                                        ),

                                        // seen & comment
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // seen
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SeenListScreen(
                                                                  seenList:
                                                                      noticeModel
                                                                          .seen)));
                                                },
                                                child: Text(
                                                  'Seen by ${noticeModel.seen.length}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ),

                                              //comment
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CommentScreen(
                                                                noticeId:
                                                                    notice.id,
                                                                profileData:
                                                                    profileData,
                                                              )));
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .keyboard_command_key,
                                                      size: 16,
                                                    ),
                                                    Text('Comment'),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        //
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Divider(height: 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
