import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/notice_model.dart';
import '/widgets/headline.dart';
import '../../models/profile_data.dart';
import 'notice_add.dart';
import 'notice_edit.dart';
import 'notice_screen.dart';

class NoticeGroup extends StatelessWidget {
  final ProfileData profileData;

  const NoticeGroup({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                horizontal: MediaQuery.of(context).size.width > 1000
                    ? MediaQuery.of(context).size.width * .2
                    : 12,
                vertical: 12,
              ),
              child: Column(
                children: [
                  // add
                  if (profileData.information.status!.cr!)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ListTile(
                        tileColor: Theme.of(context).cardColor,

                        // image
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(profileData.image),
                        ),

                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoticeAdd(
                                  profileData: profileData,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            margin: const EdgeInsets.only(right: 8),
                            child: Text(
                              'Write something...',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ),
                    ),

                  //
                  const Padding(
                    padding: EdgeInsets.only(left: 8, top: 8),
                    child: Headline(title: 'Notices'),
                  ),

                  //
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Universities')
                        .doc(profileData.university)
                        .collection('Departments')
                        .doc(profileData.department)
                        .collection('Notifications')
                        .where('batch',
                            arrayContains: profileData.information.batch)
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong'));
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
                              itemCount: data.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (BuildContext context, int index) {
                                //
                                var notice = data[index];
                                NoticeModel noticeModel =
                                    NoticeModel.fromJson(notice);

                                return Card(
                                  elevation: 0,
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                      bottom: 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(noticeModel.uploader)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const Center(
                                                    child: Text(''));
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }

                                              var uploader = snapshot.data;

                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                // image
                                                leading: CachedNetworkImage(
                                                  imageUrl:
                                                      uploader!.get('imageUrl'),
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
                                                  uploader.get('name'),
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
                                                    noticeModel.time,
                                                  ),
                                                ),

                                                //edit, delete
                                                trailing:
                                                    (profileData.information
                                                            .status!.admin!)
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
                                                                        builder:
                                                                            (context) =>
                                                                                NoticeEdit(
                                                                          noticeId:
                                                                              notice.id,
                                                                          profileData:
                                                                              profileData,
                                                                          noticeModel:
                                                                              noticeModel,
                                                                          uploader:
                                                                              uploader,
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
                                                                            'Notifications')
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
                                              );
                                            }),
                                        //

                                        //message
                                        SelectableText(
                                          noticeModel.message,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),

                                        if (noticeModel.imageUrl[0] != '')
                                          const SizedBox(height: 16),

                                        //
                                        if (noticeModel.imageUrl[0] != '')
                                          CachedNetworkImage(
                                            height: 300,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
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
