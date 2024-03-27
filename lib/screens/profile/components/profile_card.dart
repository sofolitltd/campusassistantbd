import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../profile_edit.dart';
import '/admin/admin_dashboard.dart';
import '/models/profile_data.dart';
import '/screens/auth/new_splash_screen.dart';
import '/screens/community/notice/notice_group.dart';
import '/screens/profile/moderator/moderator_dashboard.dart';

enum Profession { student, teacher }

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width * .2
              : 12,
          vertical: 12,
        ),
        child: Column(
          children: [
            //
            Stack(
              // alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                // image, name,
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    // margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            spreadRadius: 3,
                            offset: Offset(2, 1)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // image
                            profileData.image == ''
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/pp_placeholder.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: profileData.image,
                                      fadeInDuration:
                                          const Duration(milliseconds: 500),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/pp_placeholder.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/pp_placeholder.png'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                            const SizedBox(width: 12),

                            //name, status
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  Text(
                                    profileData.name,
                                    // maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),

                                  const SizedBox(height: 3),

                                  //
                                  if (profileData.profession ==
                                      Profession.student.name) ...[
                                    SizedBox(
                                      height: 18,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          //
                                          Row(
                                            children: [
                                              Text(
                                                'Blood:  ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                              Text(
                                                profileData.information.blood!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),

                                          //
                                          if (profileData.information.status!
                                                  .subscriber! ==
                                              'pro')
                                            const Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Icon(
                                                Icons.check_circle,
                                                size: 18,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                    //
                                    const SizedBox(height: 6),

                                    //id , session
                                    Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 390),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .dividerColor
                                            .withOpacity(.05),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          userBasic(
                                            context,
                                            'Batch',
                                            profileData.information.batch,
                                          ),
                                          userBasic(
                                            context,
                                            'Session',
                                            profileData.information.session,
                                          ),
                                          userBasic(
                                            context,
                                            'Student ID',
                                            profileData.information.id,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),

                        //
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          padding: const EdgeInsets.only(top: 16, bottom: 4),
                          child: Row(
                            children: [
                              //
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProfile(
                                            profileData: profileData),
                                      ),
                                    );
                                  },
                                  child: Text('Edit profile'.toUpperCase()),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // log out
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //unsubscribe
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .snapshots()
                                        .forEach((data) {
                                      ProfileData profileData =
                                          ProfileData.fromJson(data.data());

                                      var topicSource =
                                          '${profileData.university} ${profileData.department} ${profileData.information.batch!}';
                                      var topic = topicSource
                                          .replaceAll(' ', '_')
                                          .toLowerCase();
                                      log('topic: $topic');

                                      if (!kIsWeb) {
                                        FirebaseMessaging.instance
                                            .unsubscribeFromTopic(topic)
                                            .then((value) {
                                          log('unsubscribeFromTopic $topic');
                                          //
                                          logOutDialog(context);
                                        });
                                      }
                                    });
                                  },
                                  child: Text('Log out'.toUpperCase()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // contact
            Column(
              children: [
                //
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.contact_page_outlined,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Contact'),
                  subtitle: const Text('User basic information'),
                ),

                //
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      const SizedBox(height: 2),

                      //
                      Text(
                        profileData.email,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),

                      const Divider(),

                      //
                      Text(
                        'Phone',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      const SizedBox(height: 2),

                      //
                      Text(
                        profileData.mobile,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),

                      //
                      if (profileData.profession ==
                          Profession.student.name) ...[
                        const Divider(),
                        //hall title
                        Text(
                          'Hall',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),

                        const SizedBox(height: 2),

                        // hall name
                        Text(
                          profileData.information.hall!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),

            // essentials
            Column(
              children: [
                //
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.mail_outline,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Essentials'),
                  subtitle: const Text(' Notice Group, Bookmarks '),
                ),

                //
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Admin
                        if (profileData.information.status!.admin == true) ...[
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminDashboardScreen(),
                                ),
                              );
                            },
                            title: Text(
                              'Admin',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                            ),
                          ),
                          const Divider(height: 1),
                        ],

                        //moderator
                        if (profileData.information.status!.moderator ==
                            true) ...[
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ModeratorDashboard(
                                      profileData: profileData),
                                ),
                              );
                            },
                            title: Text(
                              'Moderator',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                            ),
                          ),
                          const Divider(height: 1),
                        ],

                        // notice

                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NoticeGroup(profileData: profileData),
                              ),
                            );
                          },
                          title: Text(
                            'Notice Group',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 16,
                          ),
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//
Column userBasic(BuildContext context, String title, subtitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //
      Text(
        title,
        style: Theme.of(context).textTheme.bodySmall,
      ),

      const SizedBox(height: 2),

      //
      Text(
        subtitle,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(fontWeight: FontWeight.w600),
      ),
    ],
  );
}

// logout dialog
logOutDialog(context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Log out'),
      content: const Text('Are you sure to log out?'),
      actionsPadding: const EdgeInsets.only(
        right: 12,
        left: 12,
        bottom: 12,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        //
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'.toUpperCase()),
        ),

        //
        ElevatedButton(
          onPressed: () async {
            ///log out
            await FirebaseAuth.instance.signOut().then(
              (value) {
                // got to
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewSplashScreen()),
                    (route) => false);
              },
            );
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Log out'.toUpperCase())),
        ),
      ],
    ),
  );
}
