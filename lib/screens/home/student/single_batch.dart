//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';
import '/screens/home/student/add_student.dart';
import '/screens/home/student/widgets/batch_student_card.dart';
import '../../../models/student_model.dart';
import '../../../utils/constants.dart';

class SingleBatchScreen extends StatelessWidget {
  final UserModel userModel;
  final String selectedBatch;

  const SingleBatchScreen({
    Key? key,
    required this.userModel,
    required this.selectedBatch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(userModel.university)
        .collection('Departments')
        .doc(userModel.department)
        .collection('Students')
        .doc('Batches')
        .collection(selectedBatch);

    return Scaffold(
      //
      floatingActionButton: userModel.role[UserRole.admin.name]
          ? Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: FloatingActionButton(
                onPressed: () {
                  //
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddStudent(
                        userModel: userModel,
                        selectedBatch: selectedBatch,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            )
          : null,

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.orderBy('orderBy', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(child: Text('No Data found'));
          }

          //Total Student:
          String studentCounter = '${data.length}';

          //
          return Scrollbar(
            radius: const Radius.circular(8),
            interactive: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 800
                      ? MediaQuery.of(context).size.width * .2
                      : 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    //total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //
                        Text(
                          'Total Student: ',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),

                        //
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: Text(
                            studentCounter,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              // fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // student list
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // padding: const EdgeInsets.only(
                      //   left: 16,
                      //   right: 16,
                      //   bottom: 16,
                      // ),
                      itemCount: data.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        StudentModel studentModel =
                            StudentModel.fromJson(data[index]);

                        //
                        return BatchStudentCard(
                          userModel: userModel,
                          selectedBatch: selectedBatch,
                          studentModel: studentModel,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
