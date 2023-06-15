import 'package:campusassistant/admin/batches_screen.dart';
import 'package:campusassistant/admin/student_all_screen.dart';
import 'package:flutter/material.dart';

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
            tileColor: Theme.of(context).cardColor,
            title: const Text('Batches'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BatchesScreen(
                    university: university,
                    department: department,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Students'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllStudentScreen(
                    university: university,
                    department: department,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Teachers'),
            onTap: () {
              // Get.to(() => Departments(university: university));
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Theme.of(context).cardColor,
            title: const Text('Cr'),
            onTap: () {
              // Get.to(() => Departments(university: university));
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            tileColor: Theme.of(context).cardColor,
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
