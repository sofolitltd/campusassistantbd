import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/notice_model.dart';
import '/models/user_model.dart';
import '/screens/home/notice/notice_group.dart';
import 'notice_screen.dart';

class NoticeScreenDetails extends StatelessWidget {
  final NoticeModel noticeModel;
  final UserModel userModel;
  final DocumentSnapshot uploader;

  const NoticeScreenDetails({
    Key? key,
    required this.noticeModel,
    required this.userModel,
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //
              ListTile(
                contentPadding: EdgeInsets.zero,
                // image
                leading: CachedNetworkImage(
                  imageUrl: uploader.get('imageUrl'),
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

                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // uploader
                    Text(
                      uploader.get('name'),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
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
                              userModel: userModel,
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
                          userModel.batch,
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

              //message
              SelectableText(
                noticeModel.message,
                style: noticeModel.message.length < 100
                    ? Theme.of(context).textTheme.headline5
                    : Theme.of(context).textTheme.subtitle1,
              ),

              const SizedBox(height: 16),

              //
              if(noticeModel.imageUrl[0] != '')
              CachedNetworkImage(
                height: 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                imageUrl: noticeModel.imageUrl[0],
                fadeInDuration: const Duration(milliseconds: 500),
                imageBuilder: (context, imageProvider) => InteractiveViewer(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        // fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                ),
              ),

              const Divider(height: 0),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SeenListScreen(seenList: noticeModel.seen)));
                },
                child: Text(
                  'Seen by ${noticeModel.seen.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //
              const SizedBox(height: 8),
              const Divider(height: 0),
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
        itemCount: seenList.length,
        itemBuilder: (context, index) {
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(seenList[index])
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              //
              var data = snapshot.data!;
              UserModel userModel = UserModel.fromJson(data);

              return ListTile(
                // image
                leading: CachedNetworkImage(
                  imageUrl: userModel.imageUrl,
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
                title: Text(userModel.name),
                // subtitle: Text('Id: ${userModel.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
