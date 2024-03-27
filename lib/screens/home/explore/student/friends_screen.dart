import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/profile_data.dart';
import '/models/student_model.dart';
import 'all_batch_screen.dart';
import 'widget/all_batch_card_widget.dart';
import 'widget/student_add.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .16
                : 0,
          ),
          child: const Text('Friends'),
        ),
        titleSpacing: 0,
        elevation: 0,
        actions: [
          // all student
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .198
                  : 16,
              top: 8,
              bottom: 8,
            ),
            child: MaterialButton(
              color: Colors.pink[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              onPressed: () async {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllBatchScreen(profileData: profileData),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('All Students'),
              ),
            ),
          )
        ],
      ),

      // add student
      floatingActionButton: (profileData.information.status!.cr! ||
              profileData.information.status!.moderator!)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStudent(
                      university: profileData.university,
                      department: profileData.department,
                      selectedBatch: profileData.information.batch!,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(profileData.university)
            .collection('Departments')
            .doc(profileData.department)
            .collection('students')
            .doc('batches')
            .collection(profileData.information.batch!)
            .orderBy('orderBy', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(child: Text('No data found!'));
          }

          //
          return Scrollbar(
            radius: const Radius.circular(8),
            interactive: true,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .2
                    : 16,
                vertical: 16,
              ),
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int index) {
                StudentModel studentModel = StudentModel.fromJson(data[index]);

                //
                return AllBatchCardWidget(
                  profileData: profileData,
                  studentModel: studentModel,
                  selectedBatch: profileData.information.batch!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
