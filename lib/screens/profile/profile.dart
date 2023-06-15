import 'package:flutter/material.dart';

import '/models/profile_data.dart';
import 'profile_card.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.profileData});
  final ProfileData profileData;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  //
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //for automatic keep alive
    super.build(context);
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.blueAccent.shade100,
              title: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width > 800
                      ? MediaQuery.of(context).size.width * .188
                      : 0,
                ),
                child: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
            ProfileCard(profileData: widget.profileData),
          ],
        ),
      ),
    );
  }
}
