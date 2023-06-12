import 'package:campusassistant/models/profile_data.dart';
import 'package:flutter/material.dart';

import 'profile_card.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.profileData});
  static const routeName = '/profile';

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

    //
    return Scaffold(
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
            ProfileCard(profileData: widget.profileData),
          ],
        ),
      ),
    );
  }
}
