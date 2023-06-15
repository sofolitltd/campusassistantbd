import 'package:flutter/material.dart';

import 'universities.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),

      //
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Universities()));
            },
            tileColor: Theme.of(context).cardColor,
            title: const Text('Universities'),
          ),
        ],
      ),
    );
  }
}

// university
