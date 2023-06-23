import 'package:campusassistant/admin/hall_screen.dart';
import 'package:flutter/material.dart';

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
        ),
      ),

      //
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width * .2
              : 16,
          vertical: 16,
        ),
        children: [
          ///dept
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Departments'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Departments(university: university),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          ///halls
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Halls'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HallScreen(university: university),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
