import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

  // init
  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  // banner ad
  late BannerAd bannerAd;
  bool _isAdLoaded = false;
  // String adUnitId = 'ca-app-pub-3940256099942544/6300978111'; //test id
  String adUnitId = 'ca-app-pub-2392427719761726/4292099927'; //real id

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          log('ad error: ${error.message}');
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  // widget
  @override
  Widget build(BuildContext context) {
    //for automatic keep alive
    super.build(context);
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      //app bar
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
      // drawer
      drawer: width < 800 ? const CustomDrawer() : null,

      //
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const AddNotification()));
      //   },
      //   child: const Icon(Icons.add),
      // ),

      //body
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        children: [
          //banner
          // HomeBanner(profileData: widget.profileData),
          Header(userName: widget.profileData.name),

          //more
          More(profileData: widget.profileData),

          const SizedBox(height: 8),

          //banner ad
          if (!kIsWeb && _isAdLoaded
              // && widget.profileData.information.status!.subscriber != 'pro'
          ) ...[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          ],

          // Explore
          Explore(profileData: widget.profileData),
        ],
      ),
    );
  }
}
