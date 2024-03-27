import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/profile_data.dart';
import '/models/student_model.dart';
import 'widget/all_batch_card_widget.dart';
import 'widget/student_add.dart';

class AllBatchScreen extends StatefulWidget {
  const AllBatchScreen({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  State<AllBatchScreen> createState() => _AllBatchScreenState();
}

class _AllBatchScreenState extends State<AllBatchScreen> {
  List? batches = [];

  //
  getBatches() async {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.profileData.university)
        .collection('Departments')
        .doc(widget.profileData.department)
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
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.width * .2
                        : 0,
                  ),
                  tabs: batches!.reversed
                      .map((batch) => Tab(text: batch))
                      .toList(),
                  isScrollable: true,
                ),
              ),
              body: TabBarView(
                children: batches!.reversed
                    .map(
                      (selectedBatch) => SpecificBatchScreen(
                        profileData: widget.profileData,
                        selectedBatch: selectedBatch,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }
}

//specific batch
class SpecificBatchScreen extends StatelessWidget {
  const SpecificBatchScreen({
    Key? key,
    required this.profileData,
    required this.selectedBatch,
  }) : super(key: key);

  final ProfileData profileData;

  final String selectedBatch;

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(profileData.university)
        .collection('Departments')
        .doc(profileData.department)
        .collection('students')
        .doc('batches')
        .collection(selectedBatch);

    return Scaffold(
      // add student
      floatingActionButton: (profileData.information.status!.moderator! == true)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStudent(
                      university: profileData.university,
                      department: profileData.department,
                      selectedBatch: selectedBatch,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
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
              physics: const BouncingScrollPhysics(),
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
                      itemCount: data.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (BuildContext context, int index) {
                        StudentModel studentModel =
                            StudentModel.fromJson(data[index]);

                        //
                        return AllBatchCardWidget(
                          profileData: profileData,
                          studentModel: studentModel,
                          selectedBatch: selectedBatch,
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
