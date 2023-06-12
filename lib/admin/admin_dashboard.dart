import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              Get.to(() => const Universities());
            },
            tileColor: Colors.white,
            title: const Text('Universities'),
          ),
        ],
      ),
    );
  }
}

// university
