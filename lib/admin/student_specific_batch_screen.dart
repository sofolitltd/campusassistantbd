import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '/models/student_model.dart';
import '/screens/home/explore/student/widget/all_batch_card_widget.dart';
import '/screens/home/explore/student/widget/full_image.dart';
import '/screens/home/explore/student/widget/student_add.dart';
import '../screens/home/explore/student/widget/student_edit.dart';
import '../utils/create_verification_code.dart';

class SpecificBatchScreen extends StatelessWidget {
  const SpecificBatchScreen({
    Key? key,
    required this.university,
    required this.department,
    required this.selectedBatch,
  }) : super(key: key);

  final String university;
  final String department;

  final String selectedBatch;

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection('students')
        .doc('batches')
        .collection(selectedBatch);

    return Scaffold(
      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudent(
                  university: university,
                  department: department,
                  selectedBatch: selectedBatch),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

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
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
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

                    const SizedBox(height: 16),

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
                        return StudentCard(
                          university: university,
                          department: department,
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

class StudentCard extends StatelessWidget {
  const StudentCard({
    Key? key,
    required this.university,
    required this.department,
    required this.studentModel,
    required this.selectedBatch,
  }) : super(key: key);

  final String university;
  final String department;
  final String selectedBatch;
  final StudentModel studentModel;

  @override
  Widget build(BuildContext context) {
    String shareToken = 'Name: ${studentModel.name}'
        '\nID: ${studentModel.id}'
        '\nBatch: $selectedBatch'
        '\n\nYour verification code is: \n${studentModel.token}'
        '\n\nFor Android - https://play.google.com/store/apps/details?id=com.sofolit.campusassistant'
        '\n\nFor Apple device or Website - https://campusassistantbd.web.app';
    //
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        //
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          margin: const EdgeInsets.all(0),
          child: Column(
            children: [
              // info
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    //
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 64,
                        width: 64,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullImage(
                                  title: studentModel.name,
                                  imageUrl: studentModel.imageUrl,
                                ),
                              ),
                            );
                          },
                          child: studentModel.imageUrl == ''
                              ? Image.asset('assets/images/pp_placeholder.png')
                              : CachedNetworkImage(
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  imageUrl: studentModel.imageUrl,
                                  fadeInDuration:
                                      const Duration(milliseconds: 500),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/pp_placeholder.png',
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/pp_placeholder.png',
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),
                    //
                    Expanded(
                      child: SizedBox(
                        height: 64,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              studentModel.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.black,
                                  ),
                            ),

                            // id, blood
                            Row(
                              children: [
                                //id
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 3, bottom: 1),
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'ID:  ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      children: [
                                        TextSpan(
                                          text: studentModel.id,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                if (studentModel.blood.isNotEmpty)
                                  const SizedBox(
                                    height: 16,
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                    ),
                                  ),

                                if (studentModel.blood.isNotEmpty)
                                  //blood
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3, bottom: 1),
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'Blood:  ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        children: [
                                          TextSpan(
                                            text: studentModel.blood,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.red,
                                                ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            //
                            if (studentModel.hall != 'None') ...[
                              const SizedBox(height: 4),
                              Text(
                                studentModel.hall,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // code
              Container(
                // height: 36,
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('Code: '),

                    const SizedBox(width: 8),

                    // copy token
                    (studentModel.token != 'USED')
                        ? GestureDetector(
                            onTap: () async {
                              //add verify code
                              await addVerificationCode(studentModel,
                                  university, department, selectedBatch);

                              // copy
                              Clipboard.setData(ClipboardData(text: shareToken))
                                  .then((value) => Fluttertoast.showToast(
                                      msg: 'Copy to clipboard'));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.copy_outlined, size: 16),
                                  const SizedBox(width: 4),
                                  Text(studentModel.token),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade300,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 8,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline_outlined,
                                    size: 16),
                                const SizedBox(width: 4),
                                Text(studentModel.token),
                              ],
                            ),
                          ),

                    const SizedBox(width: 8),

                    //
                    if (studentModel.token != 'USED')
                      GestureDetector(
                        onTap: () async {
                          //add verify code
                          await addVerificationCode(studentModel, university,
                              department, selectedBatch);

                          // share
                          Share.share(shareToken);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.share_outlined, size: 16),
                              SizedBox(width: 4),
                              Text('Share'),
                            ],
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Regenerate Code'),
                              content: const Text(
                                  'Sure to Regenerate verification code?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel')),

                                //
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(40, 40)),
                                    onPressed: () async {
                                      String code = createToken();

                                      // check code already exist
                                      await FirebaseFirestore.instance
                                          .collection('verifications')
                                          .doc(code)
                                          .get()
                                          .then((element) {
                                        if (element.exists) {
                                          String newCode = createToken();
                                          code = newCode;
                                          dev.log('New Code: $code');
                                        } else {
                                          dev.log('Old Code: $code');
                                        }
                                      });

                                      //add to /verifications
                                      await FirebaseFirestore.instance
                                          .collection('verifications')
                                          .doc(code)
                                          .set({
                                        'university': university,
                                        'department': department,
                                        'profession': 'student',
                                        'code': code,
                                        'name': studentModel.name,
                                        'information': {
                                          'batch': selectedBatch,
                                          'id': studentModel.id,
                                          'session': studentModel.session,
                                          'hall': studentModel.hall,
                                          'blood': studentModel.blood,
                                        }
                                      });

                                      // update code in student db
                                      await FirebaseFirestore.instance
                                          .collection('Universities')
                                          .doc(university)
                                          .collection('Departments')
                                          .doc(department)
                                          .collection('students')
                                          .doc('batches')
                                          .collection(selectedBatch)
                                          .doc(studentModel.id)
                                          .update({
                                        'token': code,
                                        'imageUrl': '',
                                      });

                                      //delete image
                                      if (studentModel.imageUrl != '') {
                                        await FirebaseStorage.instance
                                            .refFromURL(studentModel.imageUrl)
                                            .delete();
                                      }

                                      // add to trash
                                      String uid = '';
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .where('email',
                                              isEqualTo: studentModel.email)
                                          .get()
                                          .then((value) async {
                                        for (var element in value.docs) {
                                          if (element.exists) {
                                            uid = await element.get('uid');
                                            dev.log('uid exist: $uid');
                                          } else {
                                            dev.log('no email found');
                                          }
                                        }
                                      });

                                      // for admin to delete later
                                      await FirebaseFirestore.instance
                                          .collection('trash')
                                          .doc(studentModel.email)
                                          .set({
                                        'email': studentModel.email,
                                        'uid': uid,
                                      });

                                      // delete user
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(uid)
                                          .delete()
                                          .then((value) {
                                        // Navigator.pop(context);
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Generate')),

                                const SizedBox(width: 4),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).dividerColor,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.touch_app_outlined, size: 16),
                              SizedBox(width: 4),
                              Text('Regenerate Code'),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //
        PopupMenuButton(
          itemBuilder: (context) => [
            //delete
            PopupMenuItem(
                value: 1,
                onTap: () {
                  //
                  Future(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditStudent(
                          university: university,
                          department: department,
                          selectedBatch: selectedBatch,
                          studentModel: studentModel,
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Edit')),

            //delete
            PopupMenuItem(
                value: 2,
                onTap: () async {
                  // delete from verification
                  await FirebaseFirestore.instance
                      .collection('verifications')
                      .where('code', isEqualTo: studentModel.token)
                      .get()
                      .then((value) {
                    for (var element in value.docs) {
                      String id = element.id;
                      FirebaseFirestore.instance
                          .collection('verifications')
                          .doc(id)
                          .delete();
                    }
                  });

                  // delete from student list
                  await FirebaseFirestore.instance
                      .collection('Universities')
                      .doc(university)
                      .collection('Departments')
                      .doc(department)
                      .collection('students')
                      .doc('batches')
                      .collection(selectedBatch)
                      .doc(studentModel.id)
                      .delete();
                },
                child: const Text('Delete')),
          ],
        ),
      ],
    );
  }
}
