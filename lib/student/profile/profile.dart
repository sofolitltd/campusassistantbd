import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '/auth/login/login.dart';
import '/models/user_model.dart';
import '../../utils/constants.dart';
import '../home/notice/notice_group.dart';
import '../study/course6_bookmarks.dart';
import 'admin.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  //
  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  //
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //for automatic keep alive
    super.build(context);

    //
    var currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      //
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.blueAccent.shade100,
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ];
        },
        body: Stack(
          children: [
            // bg
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),

            //
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('something wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var docs = snapshot.data!;
                UserModel userModel = UserModel.fromJson(docs);

                //
                return profileCard(context, userModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  //
  Widget profileCard(BuildContext context, UserModel userModel) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 1000
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
                      children: [
                        //
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // image
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: userModel.imageUrl,
                                fadeInDuration:
                                    const Duration(milliseconds: 500),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
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
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/pp_placeholder.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
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
                                    userModel.name,
                                    // maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),

                                  // const SizedBox(height: 2),

                                  //
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //
                                      Text(
                                        'Blood group (${userModel.blood})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),

                                      //
                                      if (userModel.status == 'Pro')
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Icon(
                                            Icons.check_circle,
                                            size: 20,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  //
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).dividerColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        userBasic(
                                          context,
                                          'Batch',
                                          userModel.batch,
                                        ),
                                        userBasic(
                                          context,
                                          'Session',
                                          userModel.session,
                                        ),
                                        userBasic(
                                          context,
                                          'Student ID',
                                          userModel.id,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // const SizedBox(height: 12),

                        //
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 4),
                          child: Row(
                            children: [
                              //
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Get.to(
                                      EditProfile(userModel: userModel),
                                      transition: Transition.zoom,
                                    );
                                  },
                                  child: const Text('Edit profile'),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // log out
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //
                                    logOutDialog(context);
                                  },
                                  child: const Text('Log out'),
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
                  title: const Text('Contact Information'),
                  subtitle: const Text('Email, Phone, Hall'),
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
                        userModel.email,
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
                        userModel.phone,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),

                      const Divider(),

                      //
                      Text(
                        'Hall',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      const SizedBox(height: 2),

                      //
                      Text(
                        userModel.hall,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // content
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
                        if (userModel.role[UserRole.admin.name])
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Admin(
                                    userModel: userModel,
                                  ),
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

                        if (userModel.role[UserRole.admin.name])
                          const Divider(height: 1),

                        // notice
                        if (userModel.role[UserRole.admin.name])
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NoticeGroup(userModel: userModel),
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

                        if (userModel.role[UserRole.admin.name])
                          const Divider(height: 1),

                        //bookmarks
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseBookMarks(
                                  userModel: userModel,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            'Bookmarks',
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
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
          bottom: 12,
        ),
        actions: [
          //
          OutlinedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('No'),
          ),

          //
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              //
              Get.offAll(const LoginScreen());
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}
