import 'package:cached_network_image/cached_network_image.dart';
import 'package:campusassistant/admin/student_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../models/student_model.dart';
import '../../../../student/home/student/widgets/student_card.dart';

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
        .collection('Students')
        .doc('Batches')
        .collection(selectedBatch);

    return Scaffold(
      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddStudent(
              university: university,
              department: department,
              selectedBatch: selectedBatch));
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
    required this.studentModel,
    required this.selectedBatch,
  }) : super(key: key);

  final String selectedBatch;
  final StudentModel studentModel;

  @override
  Widget build(BuildContext context) {
    //
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.all(0),
      child: Padding(
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
                    Get.to(
                      () => FullImage(
                        title: studentModel.name,
                        imageUrl: studentModel.imageUrl,
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
                          fadeInDuration: const Duration(milliseconds: 500),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/pp_placeholder.png',
                            ),
                          ),
                          errorWidget: (context, url, error) => ClipRRect(
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
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            // color: Colors.black,
                          ),
                    ),

                    // id, blood
                    Row(
                      children: [
                        //id
                        Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 1),
                          child: Text.rich(
                            TextSpan(
                              text: 'ID:  ',
                              style: Theme.of(context).textTheme.bodyMedium,
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
                            padding: const EdgeInsets.only(top: 3, bottom: 1),
                            child: Text.rich(
                              TextSpan(
                                text: 'Blood:  ',
                                style: Theme.of(context).textTheme.bodyMedium,
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
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
    );
  }
}
