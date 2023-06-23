import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

import '/models/profile_data.dart';
import '/screens/home/header.dart';
import '/screens/home/more/more.dart';
import '/widgets/custom_drawer.dart';
import '../community/notice/notice_screen.dart';
import '../community/notice/notification_badge.dart';
import 'explore/explore.dart';

enum Profession { student, teacher }

class Home extends StatefulWidget {
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
      appBar: AppBar(
        centerTitle: width < 800 ? true : false,
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .186
                : 0,
          ),
          child: Row(
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
        ),
        actions: [
          /// notification
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .186
                  : 0,
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                //
                IconButton(
                  onPressed: () {
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoticeScreen(
                          profileData: widget.profileData,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                  ),
                ),

                //  Notification Badge
                Positioned(
                  top: 5,
                  right: 5,
                  child: NotificationBadge(
                    profileData: widget.profileData,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      drawer: width < 800 ? const CustomDrawer() : null,

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
