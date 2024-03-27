import 'package:campusassistant/screens/home/more/blood/blood.dart';
import 'package:flutter/material.dart';

import '/models/profile_data.dart';
import '/screens/home/more/clubs/clubs.dart';
import '/screens/home/more/emergency/emergency.dart';
import 'routine/routine.dart';
import 'transport/transport.dart';

class More extends StatelessWidget {
  final ProfileData profileData;

  const More({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      // color: Colors.green,
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width > 800
            ? MediaQuery.of(context).size.width * .19
            : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // const Headline(title: 'More'),

          //list
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: moreList.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              separatorBuilder: (context, index) => const SizedBox(width: 4),
              itemBuilder: (context, index) => MoreCard(
                index: index,
                profileData: profileData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
class MoreCard extends StatelessWidget {
  final ProfileData profileData;
  final int index;

  const MoreCard({
    super.key,
    required this.index,
    required this.profileData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (index) {
          case 0:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Routine(
                          profileData: profileData,
                        )));
            break;
          case 1:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Emergency(profileData: profileData)));
            break;
          case 2:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Transport(profileData: profileData)));
            break;
          case 3:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BloodBank(profileData: profileData)));
          case 4:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Clubs(profileData: profileData)));
        }
      },
      child: Container(
        constraints: const BoxConstraints(minWidth: 80),
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            CircleAvatar(
              radius: 26,
              backgroundColor:
                  index.isEven ? Colors.blue.shade50 : Colors.purple.shade50,
              child: Image.asset(
                moreList[index].imageUrl,
                fit: BoxFit.cover,
                height: 32,
                width: 32,
              ),
            ),

            const SizedBox(height: 8),

            //
            Text(
              '${moreList[index].name}'.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  // fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

List moreList = [
  MoreModel(
    name: 'Routine',
    route: 'routine',
    imageUrl: 'assets/images/routine.png',
    color: 0xff012544,
  ),
  MoreModel(
      name: 'Emergency',
      route: 'emergency',
      imageUrl: 'assets/images/emergency.png',
      color: 0xff012544),
  MoreModel(
    name: 'Transports',
    route: 'transports',
    imageUrl: 'assets/images/transports.png',
    color: 0xff012544,
  ),
  MoreModel(
    name: 'Blood',
    route: 'blood',
    imageUrl: 'assets/images/syllabus.png',
    color: 0xff012544,
  ),
  MoreModel(
    name: 'Clubs',
    route: 'clubs',
    imageUrl: 'assets/images/clubs.png',
    color: 0xff012544,
  ),
];

//
class MoreModel {
  final String name;
  final String route;
  final String imageUrl;
  final int color;

  MoreModel({
    required this.name,
    required this.route,
    required this.imageUrl,
    required this.color,
  });
}
