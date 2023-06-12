import 'package:campusassistant/models/profile_data.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class More extends StatelessWidget {
  final ProfileData profileData;

  const More({
    Key? key,
    required this.profileData,
  }) : super(key: key);

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
    Key? key,
    required this.index,
    required this.profileData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/${moreList[index].route}',
          arguments: {
            'profileData': profileData,
          },
        );
      },
      child: Container(
        width: 80,
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
              moreList[index].name.toString(),
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
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
    name: 'Syllabus',
    route: 'syllabus',
    imageUrl: 'assets/images/syllabus.png',
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
