import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 64,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Campus'.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                height: 1,
                color: Color(0xFFf69520),
              ),
            ),
            Text(
              'Assistant'.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Color(0xff6dc7b2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
