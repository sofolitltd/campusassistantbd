//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'department_details.dart';

class Departments extends StatelessWidget {
  const Departments({super.key, required this.university});

  final String university;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Departments'),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc(university)
              .collection('Departments')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No data found'));
            }

            return ListView.separated(
              itemCount: docs.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 16),
              itemBuilder: (context, index) {
                //
                return GestureDetector(
                  onTap: () {
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DepartmentDetails(
                          university: university,
                          department: docs[index].get('name'),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //img
                          Container(
                            height: 64,
                            width: 64,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.shade100,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    NetworkImage(docs[index].get('imageUrl')),
                              ),
                            ),
                          ),

                          //
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    docs[index].get('name'),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Fluttertoast.showToast(
                                              msg: docs[index].get('about'));
                                        },
                                        child: const Text(
                                          'About',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                          'Established: ${docs[index].get('establish')}'),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(docs[index].get('website')),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
