import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  final String title;

  const Headline({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              // fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: Colors.grey,
            ),
      ),
    );
  }
}
