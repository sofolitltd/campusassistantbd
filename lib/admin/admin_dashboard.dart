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
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.width * .2
              : 16,
          vertical: 16,
        ),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Universities()));
            },
            child: Container(
                height: 64,
                color: Theme.of(context).cardColor,
                alignment: Alignment.center,
                child: Text(
                  'Universities',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                )),
          ),
        ],
      ),
    );
  }
}

// university
