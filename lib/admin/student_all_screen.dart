import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'student_specific_batch_screen.dart';

class AllStudentScreen extends StatefulWidget {
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
