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
              shrinkWrap: true,
              itemCount: moreList.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              separatorBuilder: (context, index) => const SizedBox(width: 8),
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
          '/${moreList[index].id}',
          arguments: userModel,
        );
      },
      child: Container(
        constraints: const BoxConstraints(minWidth: 100),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(
                moreList[index].imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 8),

            //
            Text(
              moreList[index].id.toString().toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}

List moreList = [
  MoreModel(name: 'routine', imageUrl: 'assets/images/routine.png'),
  MoreModel(name: 'syllabus', imageUrl: 'assets/images/syllabus.png'),
  MoreModel(name: 'emergency', imageUrl: 'assets/images/emergency.png'),
  MoreModel(name: 'transports', imageUrl: 'assets/images/transports.png'),
  MoreModel(name: 'clubs', imageUrl: 'assets/images/clubs.png'),
];

//
class MoreModel {
  String name;
  String imageUrl;

  MoreModel({
    required this.name,
    required this.imageUrl,
  });
}
