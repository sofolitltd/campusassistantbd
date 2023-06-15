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
        padding: const EdgeInsets.all(16),
        children: [
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
          )
        ],
      ),
    );
  }
}
