import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/notice_model.dart';
import '/models/user_model.dart';
import '/screens/home/notice/upload_notice.dart';
import '/screens/home/notice/upload_notice_edit.dart';
import '/utils/constants.dart';
import '/widgets/headline.dart';
import 'notice_screen.dart';

class NoticeGroup extends StatelessWidget {
  final UserModel userModel;
  const NoticeGroup({
    Key? key,
    required this.userModel,
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
                userModel.batch,
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
                  if (userModel.role[UserRole.cr.name])
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ListTile(
                        tileColor: Theme.of(context).cardColor,
                        // image
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(userModel.imageUrl),
                        ),

                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadNotice(
                                  userModel: userModel,
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
                              style: Theme.of(context).textTheme.subtitle1,
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
                        .doc(userModel.university)
                        .collection('Departments')
                        .doc(userModel.department)
                        .collection('Notifications')
                        .where('batch', arrayContains: userModel.batch)
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
                                        //
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          // image
                                          leading: CachedNetworkImage(
                                            imageUrl: noticeModel.uploaderImage,
                                            fadeInDuration: const Duration(
                                                milliseconds: 500),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              backgroundImage: imageProvider,
                                              // radius: 120,
                                            ),
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                const CircleAvatar(
                                                    // radius: 120,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/pp_placeholder.png')),
                                            errorWidget: (context, url,
                                                    error) =>
                                                const CircleAvatar(
                                                    // radius: 120,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/pp_placeholder.png')),
                                          ),

                                          title: Text(
                                            noticeModel.uploaderName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),

                                          //time
                                          subtitle: Text(
                                            TimeAgo.timeAgoSinceDate(
                                              noticeModel.time,
                                            ),
                                          ),

                                          //edit, delete
                                          trailing: (userModel
                                                  .role[UserRole.cr.name])
                                              ? PopupMenuButton(
                                                  itemBuilder: (context) => [
                                                    //delete
                                                    PopupMenuItem(
                                                        value: 1,
                                                        onTap: () {
                                                          //
                                                          Future(
                                                            () =>
                                                                //
                                                                Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        UploadNoticeEdit(
                                                                  noticeId:
                                                                      notice.id,
                                                                  userModel:
                                                                      userModel,
                                                                  noticeModel:
                                                                      noticeModel,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child:
                                                            const Text('Edit')),

                                                    //delete
                                                    PopupMenuItem(
                                                        value: 2,
                                                        onTap: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Universities')
                                                              .doc(userModel
                                                                  .university)
                                                              .collection(
                                                                  'Departments')
                                                              .doc(userModel
                                                                  .department)
                                                              .collection(
                                                                  'Notifications')
                                                              .doc(notice.id)
                                                              .delete();
                                                        },
                                                        child: const Text(
                                                            'Delete')),
                                                  ],
                                                )
                                              : null,
                                        ),

                                        //message
                                        SelectableText(
                                          noticeModel.message,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
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
