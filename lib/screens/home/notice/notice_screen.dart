import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/notice_model.dart';
import '/models/user_model.dart';
import 'notice_screen_details.dart';

enum ActionsList { edit, delete, cancel }

class NoticeScreen extends StatelessWidget {
  final UserModel userModel;
  const NoticeScreen({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
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
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;
          return snapshot.data!.size == 0
              ? const Center(child: Text('No notice found'))
              : ListView.separated(
                  itemCount: data.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 1000
                        ? MediaQuery.of(context).size.width * .2
                        : 0,
                    vertical: 12,
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 2),
                  itemBuilder: (BuildContext context, int index) {
                    //
                    var notice = data[index];
                    NoticeModel noticeModel = NoticeModel.fromJson(notice);

                    return Card(
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(noticeModel.uploader)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(child: Text(''));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            var uploader = snapshot.data;

                            return ListTile(
                              onTap: () async {
                                //
                                if (!noticeModel.seen.contains(userModel.uid)) {
                                  var seenList = noticeModel.seen;
                                  seenList.add(userModel.uid);

                                  //
                                  FirebaseFirestore.instance
                                      .collection('Universities')
                                      .doc(userModel.university)
                                      .collection('Departments')
                                      .doc(userModel.department)
                                      .collection('Notifications')
                                      .doc(notice.id)
                                      .update({
                                    'seen': seenList,
                                  });
                                }

                                //
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NoticeScreenDetails(
                                      userModel: userModel,
                                      noticeModel: noticeModel,
                                      uploader: uploader!,
                                    ),
                                  ),
                                );
                              },
                              selected: noticeModel.seen.contains(userModel.uid)
                                  ? false
                                  : true,
                              selectedTileColor:
                                  Colors.blueAccent.shade100.withOpacity(.2),
                              // image
                              leading: CachedNetworkImage(
                                imageUrl: uploader!.get('imageUrl'),
                                fadeInDuration:
                                    const Duration(milliseconds: 500),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundImage: imageProvider,
                                  // radius: 120,
                                ),
                                progressIndicatorBuilder: (context, url,
                                        downloadProgress) =>
                                    const CircleAvatar(
                                        // radius: 120,
                                        backgroundImage: AssetImage(
                                            'assets/images/pp_placeholder.png')),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        // radius: 120,
                                        backgroundImage: AssetImage(
                                            'assets/images/pp_placeholder.png')),
                              ),

                              //name
                              title: RichText(
                                text: TextSpan(
                                  text: uploader.get('name'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  children: const [
                                    TextSpan(
                                      text: ' added a new post.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //time
                              subtitle: Text(
                                TimeAgo.timeAgoSinceDate(
                                  noticeModel.time,
                                ),
                              ),
                            );
                          }),
                    );
                  },
                );
        },
      ),
    );
  }
}

// time ago
class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("dd-MM-yyyy h:mm a").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
