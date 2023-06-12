import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/student_model.dart';
import '/models/user_model.dart';
import '/utils/constants.dart';
import 'add_student.dart';
import 'all_batch_list.dart';
import 'widgets/student_card.dart';

class StudentScreen extends StatelessWidget {
  static const routeName = '/student';

  const StudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(userModel.university)
        .collection('Departments')
        .doc(userModel.department);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        // centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
        actions: [
          // all batch
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: MaterialButton(
                color: Colors.pink[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () async {
                  List batchList = [];
                  await FirebaseFirestore.instance
                      .collection('Universities')
                      .doc(userModel.university)
                      .collection('Departments')
                      .doc(userModel.department)
                      .collection('Batches')
                      .orderBy('name')
                      .get()
                      .then(
                    (QuerySnapshot snapshot) {
                      for (var batch in snapshot.docs) {
                        batchList.add(batch.get('name'));
                      }
                    },
                  );

                  //
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllBatchList(
                                userModel: userModel,
                                batchList: batchList,
                              )));
                },
                child: const Text('All Student',
                    style: TextStyle(color: Colors.black87))),
          )
        ],
      ),
      //
      floatingActionButton: userModel.role[UserRole.cr.name]
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
                        selectedBatch: userModel.batch,
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
        stream: ref
            .collection('Students')
            .doc('Batches')
            .collection(userModel.batch)
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
                return StudentCard(
                    userModel: userModel, studentModel: studentModel);
              },
            ),
          );
        },
      ),
    );
  }
}
