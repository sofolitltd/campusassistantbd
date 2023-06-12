import 'package:campusassistant/teacher/home/header.dart';
import 'package:campusassistant/teacher/home/more/more.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

import '../../models/profile_data.dart';
import '../../student/home/components/custom_drawer.dart';
import 'explore/explore.dart';

enum Profession { student, teacher }

class Home extends StatefulWidget {
  static const routeName = '/home';

  const Home({Key? key, required this.profileData}) : super(key: key);
  final ProfileData profileData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //for automatic keep alive
    super.build(context);
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: Colors.greenAccent.shade100.withOpacity(.2),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Campus'.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Color(0xFFf69520),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Assistant'.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Color(0xff6dc7b2),
              ),
            ),
          ],
        ),
        actions: [
          // todo: delete later [use to copy Users -> users]
          //
          // IconButton(
          //   onPressed: () {
          //     var ref1 = FirebaseFirestore.instance.collection('Users');
          //     var ref2 = FirebaseFirestore.instance.collection('users');
          //     ref1.get().then(
          //           (snap) {
          //         for (var doc in snap.docs) {
          //           //
          //           ProfileData profileData = ProfileData(
          //             uid: doc.get('uid'),
          //             university: doc.get('university'),
          //             department: doc.get('department'),
          //             profession: 'student',
          //             name: doc.get('name'),
          //             mobile: doc.get('phone'),
          //             email: doc.get('email'),
          //             image: doc.get('imageUrl'),
          //             token: '',
          //             information: Information(
          //               batch: doc.get('batch'),
          //               id: doc.get('id'),
          //               session: doc.get('session'),
          //               hall: doc.get('hall'),
          //               blood: doc.get('blood'),
          //               status: Status(
          //                 subscriber:
          //                 doc.get('status').toString().toLowerCase(),
          //                 moderator: doc.get('role')['cr'],
          //                 admin: doc.get('role')['admin'],
          //                 cr: doc.get('role')['cr'],
          //               ),
          //             ),
          //           );
          //           // log('${doc.id} => ${jsonEncode(profileData.toJson())}');
          //           // ref2.doc(doc.id).set(profileData.toJson());
          //         }
          //       },
          //     );
          //   },
          //   icon: const Icon(Icons.add),
          // ),

          /// notificaton
          //todo:
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => NoticeScreen(
          //           profileData: widget.profileData,
          //         ),
          //       ),
          //     );
          //   },
          //   child: Stack(
          //     alignment: Alignment.topRight,
          //     children: [
          //       //
          //       IconButton(
          //         onPressed: () {
          //           //
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => NoticeScreen(
          //                 profileData: widget.profileData,
          //               ),
          //             ),
          //           );
          //         },
          //         icon: const Icon(
          //           Icons.notifications_outlined,
          //         ),
          //       ),
          //
          //       //  Notification Badge
          //       const Positioned(
          //         top: 6,
          //         right: 6,
          //         child: NotificationBadge(),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(width: 12),
        ],
      ),
      drawer: width < 600 ? const CustomDrawer() : null,

      //
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const AddNotification()));
      //   },
      //   child: const Icon(Icons.add),
      // ),

      //
      body: UpgradeAlert(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          children: [
            //banner
            // HomeBanner(profileData: widget.profileData),
            Header(userName: widget.profileData.name),

            // const SizedBox(height: 16),

            //more
            More(profileData: widget.profileData),

            const SizedBox(height: 8),

            // Explore
            Explore(profileData: widget.profileData),
          ],
        ),
      ),
    );
  }
}