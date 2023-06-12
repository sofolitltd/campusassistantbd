import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import 'departments.dart';

class UniversityDetails extends StatelessWidget {
  const UniversityDetails({super.key, required this.university});

  final String university;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          university,
          style: const TextStyle(color: Colors.black),
        ),
      ),

      //
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            tileColor: Colors.white,
            title: const Text('Departments'),
            onTap: () {
              Get.to(() => Departments(university: university));
            },
          )
        ],
      ),
    );
  }
}
