import 'package:flutter/material.dart';

class Clubs extends StatelessWidget {
  static const routeName = '/clubs';

  const Clubs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clubs'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('No data found'),
      ),
    );
  }
}
