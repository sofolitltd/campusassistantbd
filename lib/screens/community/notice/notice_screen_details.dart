import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/notice_model.dart';
import '/models/profile_data.dart';
import '/screens/community/notice/comment_screen.dart';
import '/screens/home/explore/student/widget/full_image.dart';
import 'notice_group.dart';
import 'notice_screen.dart';

class NoticeScreenDetails extends StatelessWidget {
  final NoticeModel noticeModel;
  final String noticeId;
  final ProfileData profileData;
  final DocumentSnapshot uploader;

  const NoticeScreenDetails({
    Key? key,
    required this.noticeModel,
    required this.noticeId,
    required this.profileData,
    required this.uploader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
      ),

      //
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  // image
                  leading: CachedNetworkImage(
                    imageUrl: uploader.get('image'),
                    fadeInDuration: const Duration(milliseconds: 500),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                      // radius: 120,
                    ),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => const CircleAvatar(
                            // radius: 120,
                            backgroundImage:
                                AssetImage('assets/images/pp_placeholder.png')),
                    errorWidget: (context, url, error) => const CircleAvatar(
                        // radius: 120,
                        backgroundImage:
                            AssetImage('assets/images/pp_placeholder.png')),
                  ),

                  title: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // uploader
                      Text(
                        uploader.get('name'),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      //
                      const Icon(Icons.arrow_right_outlined),

                      // to
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoticeGroup(
                                profileData: profileData,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: Text(
                            profileData.information.batch!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //time
                  subtitle: Text(
                    TimeAgo.timeAgoSinceDate(
                      noticeModel.time,
                    ),
                  ),
                ),
              ),

              //message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SelectableText(
                  noticeModel.message,
                  style: noticeModel.message.length < 100
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.titleMedium,
                ),
              ),

              const SizedBox(height: 16),

              //
              if (noticeModel.imageUrl[0] != '')
                Container(
                  color: Colors.grey.shade300,
                  child: CachedNetworkImage(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    imageUrl: noticeModel.imageUrl[0],
                    fadeInDuration: const Duration(milliseconds: 500),
                    imageBuilder: (context, imageProvider) => GestureDetector(
                      onTap: () {
                        //
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullImage(
                              imageUrl: noticeModel.imageUrl[0],
                              title: noticeModel.message,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade100,
                      ),
                    ),
                  ),
                ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 0),
              ),

              // seen & comment
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // seen
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeenListScreen(
                                    seenList: noticeModel.seen)));
                      },
                      child: Text(
                        'Seen by ${noticeModel.seen.length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),

                    //comment
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentScreen(
                                      noticeId: noticeId,
                                      profileData: profileData,
                                    )));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_command_key,
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
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
class SeenListScreen extends StatelessWidget {
  final List seenList;

  const SeenListScreen({Key? key, required this.seenList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People who reached'),
      ),

      //
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: seenList.length,
        itemBuilder: (context, index) {
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(seenList[index])
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const SizedBox();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              //
              var data = snapshot.data!;
              ProfileData profileData =
                  ProfileData.fromJson(data.data() as Map<String, dynamic>);

              return ListTile(
                // image
                leading: CachedNetworkImage(
                  imageUrl: profileData.image,
                  fadeInDuration: const Duration(milliseconds: 500),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                    // radius: 120,
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const CircleAvatar(
                          // radius: 120,
                          backgroundImage:
                              AssetImage('assets/images/pp_placeholder.png')),
                  errorWidget: (context, url, error) => const CircleAvatar(
                      // radius: 120,
                      backgroundImage:
                          AssetImage('assets/images/pp_placeholder.png')),
                ),

                //
                title: Text(profileData.name),
                // subtitle: Text('Id: ${userModel.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
