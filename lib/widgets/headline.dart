import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  final String title;

  const Headline({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              // fontSize: 20,
              fontWeight: FontWeight.bold,
              // color: Colors.black87,
            ),
      ),
    );
  }
}
