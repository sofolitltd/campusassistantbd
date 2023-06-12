import 'package:flutter/material.dart';

import '/models/user_model.dart';
import '/widgets/headline.dart';

class More extends StatelessWidget {
  final UserModel userModel;

  const More({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width > 1000
            ? MediaQuery.of(context).size.width * .2
            : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          const Headline(title: 'Explore'),

          //list
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: moreList.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) => MoreCard(
                index: index,
                userModel: userModel,
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
  final UserModel userModel;
  final int index;

  const MoreCard({
    Key? key,
    required this.index,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/${moreList[index].name}',
          arguments: userModel,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          CircleAvatar(
            radius: 32,
            backgroundColor:
                index.isEven ? Colors.blue.shade50 : Colors.pink.shade50,
            child: Image.asset(
              moreList[index].imageUrl,
              fit: BoxFit.cover,
              height: 35,
              width: 35,
            ),
          ),

          const SizedBox(height: 8),

          //
          Text(
            moreList[index].name.toString().toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

List moreList = [
  MoreModel(
    name: 'routine',
    imageUrl: 'assets/images/routine.png',
    color: 0xff012544,
  ),
  MoreModel(
    name: 'syllabus',
    imageUrl: 'assets/images/syllabus.png',
    color: 0xff012544,
  ),
  MoreModel(
      name: 'emergency',
      imageUrl: 'assets/images/emergency.png',
      color: 0xff012544),
  MoreModel(
    name: 'transports',
    imageUrl: 'assets/images/transports.png',
    color: 0xff012544,
  ),
  MoreModel(
    name: 'clubs',
    imageUrl: 'assets/images/clubs.png',
    color: 0xff012544,
  ),
];

//
class MoreModel {
  final String name;
  final String imageUrl;
  final int color;

  MoreModel({
    required this.name,
    required this.imageUrl,
    required this.color,
  });
}
