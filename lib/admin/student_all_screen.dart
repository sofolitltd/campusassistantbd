import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../models/student_model.dart';
import 'student_specific_batch_screen.dart';

class AllStudentScreen extends StatefulWidget {
  static const routeName = '/student';

  const AllStudentScreen(
      {super.key, required this.university, required this.department});

  final String university;
  final String department;

  @override
  State<AllStudentScreen> createState() => _AllStudentScreenState();
}

class _AllStudentScreenState extends State<AllStudentScreen> {
  List? batches = [];

  //
  getBatches() async {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
        .collection('Departments')
        .doc(widget.department)
        .collection('batches')
        .orderBy('name')
        .snapshots();

    //
    await ref.forEach((snapshot) {
      for (var data in snapshot.docs) {
        var batch = data.get('name');
        batches!.add(batch);
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getBatches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (batches == [])
        ? const Center(child: CircularProgressIndicator())
        : DefaultTabController(
            length: batches!.length,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: const Text('All Students'),
                bottom: TabBar(
                  tabs: batches!.reversed
                      .map((batch) => Tab(text: batch))
                      .toList(),
                  isScrollable: true,
                ),
              ),

              //
              body: TabBarView(
                children: batches!.reversed
                    .map(
                      (selectedBatch) => SpecificBatchScreen(
                        university: widget.university,
                        department: widget.department,
                        selectedBatch: selectedBatch,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }
}

//
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
    //
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 8,
          bottom: 5,
        ),
        horizontalTitleGap: 12,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: GestureDetector(
            onTap: () {
              // Get.to(FullImage(imageUrl: studentModel.imageUrl));
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
                                'assets/images/pp_placeholder.png')),
                    errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/images/pp_placeholder.png')),
                  ),
          ),
        ),
        title: Text(
          studentModel.name,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                // color: Colors.black,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // id, blood
            Row(
              children: [
                //id
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 1),
                  child: Text.rich(
                    TextSpan(
                      text: 'ID: ',
                      style: Theme.of(context).textTheme.titleSmall,
                      children: [
                        TextSpan(
                          text: studentModel.id,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
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
                        style: Theme.of(context).textTheme.titleSmall,
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
            if (studentModel.hall != 'None')
              Text(
                studentModel.hall,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }
}
