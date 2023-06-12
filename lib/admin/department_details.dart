import 'package:campusassistant/admin/batches_screen.dart';
import 'package:campusassistant/admin/student_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class DepartmentDetails extends StatelessWidget {
  const DepartmentDetails(
      {super.key, required this.university, required this.department});

  final String university;
  final String department;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              department,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              university,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),

      //
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            tileColor: Colors.white,
            title: const Text('Batches'),
            onTap: () {
              Get.to(() => BatchesScreen(
                    university: university,
                    department: department,
                  ));
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Colors.white,
            title: const Text('Students'),
            onTap: () {
              Get.to(() => AllStudentScreen(
                    university: university,
                    department: department,
                  ));
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Colors.white,
            title: const Text('Teachers'),
            onTap: () {
              // Get.to(() => Departments(university: university));
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Colors.white,
            title: const Text('Cr'),
            onTap: () {
              // Get.to(() => Departments(university: university));
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Colors.white,
            title: const Text('Staff'),
            onTap: () {
              // Get.to(() => Departments(university: university));
            },
          ),
        ],
      ),
    );
  }
}

//
