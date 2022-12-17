import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List columnDataList = [
    'No',
    'Status',
    'Student ID',
    'Student name',
    'Date',
  ];

  // List countries = [];
  List selectedStudents = [];

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc('University of Chittagong')
        .collection('Departments')
        .doc('Department of Psychology')
        .collection('Students')
        .doc('Batches')
        .collection('Batch 14');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Attendance'),
        ),

        //
        body: FutureBuilder<QuerySnapshot>(
          future: ref.orderBy('orderBy', descending: false).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var doc = snapshot.data!.docs;

            if (doc.isEmpty) {
              return const Center(child: Text('No Data found'));
            }

            //Total Student:
            String studentCounter = '${doc.length}';
            int rank = 0;

            final ScrollController controller = ScrollController();
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  //
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Course code: Psy 401'),
                            Text(
                                'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}'),
                          ],
                        ),
                        //
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total: ${doc.length}'),
                            Row(
                              children: [
                                Text('Present: ${selectedStudents.length}'),
                                const SizedBox(width: 8),
                                Text(
                                    'Absent: ${doc.length - selectedStudents.length}'),
                              ],
                            ),
                          ],
                        ),
                        //
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              // minimumSize: const Size(150, 48),
                            ),
                            onPressed: () {
                              //
                              // /Universities/University of Chittagong/Departments/Department of Psychology
                              var ref = FirebaseFirestore.instance
                                  .collection('Universities')
                                  .doc('University of Chittagong')
                                  .collection('Departments')
                                  .doc('Department of Psychology');
                              var date = DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now());
                              var docId = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              ref.collection('Attendance').doc(docId).set({
                                'date': date,
                                'attendance': selectedStudents,
                                'teacher': 'bd',
                                'courseCode': 'Psy 401',
                                'batch': 'Batch 14',
                              });
                            },
                            child: const Text('Save data')),
                      ],
                    ),
                  ),
                  //
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: columnDataList
                              .map((data) => DataColumn(label: Text(data)))
                              .toList(),
                          rows: doc
                              .map(
                                (data) => DataRow(
                                  selected: selectedStudents.contains(data.id),
                                  onSelectChanged: (isSelected) => setState(() {
                                    final isAdding =
                                        isSelected != null && isSelected;

                                    isAdding
                                        ? selectedStudents.add(data.id)
                                        : selectedStudents.remove(data.id);
                                  }),
                                  cells: [
                                    DataCell(Text(getRank(rank, doc, data.id)
                                        .toString())),
                                    // DataCell(
                                    //   Text('1'),
                                    // ),
                                    DataCell(
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color:
                                              selectedStudents.contains(data.id)
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          selectedStudents.contains(data.id)
                                              ? 'Present'
                                              : 'Absent',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text('${data.get('id')}')),
                                    DataCell(Text('${data.get('name')}')),
                                    DataCell(
                                      Text(DateFormat('dd-MM-yyyy')
                                          .format(DateTime.now())),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  //
  getRank(
    int rank,
    var data,
    String? uid,
  ) {
    for (int i = 0; i < data.length; i++) {
      if (uid == data[i].reference.id) {
        rank = i + 1;
      }
    }
    return rank;
  }
}

//
class AttendanceTable extends StatelessWidget {
  const AttendanceTable({
    Key? key,
    required this.columnDataList,
    required this.rowsData,
  }) : super(key: key);

  final List columnDataList;
  final List rowsData;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns:
          columnDataList.map((data) => DataColumn(label: Text(data))).toList(),
      rows: rowsData
          .map(
            (data) => DataRow(
              cells: [
                DataCell(Text('${data}')),
                DataCell(
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.purpleAccent.shade200,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: const Text(
                      'Not set',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const DataCell(Text('18608047')),
                const DataCell(Text('Md Asifuzzaman Reyad')),
                const DataCell(Text('Md Asifuzzaman Reyad')),
              ],
            ),
          )
          .toList(),
    );
  }
}

//
class AttendanceData {
  final String id;
  final String name;
  final String status;

  const AttendanceData({
    required this.status,
    required this.id,
    required this.name,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
        id: json['id'],
        status: json['code'],
        name: json['native'],
      );
}
