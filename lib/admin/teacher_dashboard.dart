import 'package:campusassistant/admin/attendance.dart';
import 'package:flutter/material.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Text(
                'Hello Sir',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 16),
              //
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  //
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Attendance()));
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: const [
                      Expanded(
                        child: Placeholder(),
                      ),

                      //
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Attendance'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
