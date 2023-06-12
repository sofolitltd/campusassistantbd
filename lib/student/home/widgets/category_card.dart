import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.title,
    required this.color,
    required this.routeName,
    required this.args,
  }) : super(key: key);
  final String title;
  final Color color;
  final String routeName;
  final UserModel args;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        routeName,
        arguments: args,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 6,
              spreadRadius: 1,
              // offset: Offset(1, 2), // changes position of shadow
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                heroTag: routeName,
                onPressed: () => Navigator.pushNamed(
                  context,
                  routeName,
                  arguments: args,
                ),
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  // color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
