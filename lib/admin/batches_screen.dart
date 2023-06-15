import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BatchesScreen extends StatelessWidget {
  const BatchesScreen(
      {Key? key, required this.university, required this.department})
      : super(key: key);

  final String university;
  final String department;

  @override
  Widget build(BuildContext context) {
    String name = '';
    bool study = true;

    //
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Batches',
        ),
      ),

      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // todo: change to page later
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              titlePadding: const EdgeInsets.only(left: 16),
              actionsPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  const Text('Add Batch'),

                  //
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
              actions: [
                //
                TextField(
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    name = val;
                  },
                ),

                const SizedBox(height: 16),

                //
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        //
                        if (name != '') {
                          var ref = await FirebaseFirestore.instance
                              .collection('Universities')
                              .doc(university)
                              .collection('Departments')
                              .doc(department)
                              .collection('batches')
                              .doc()
                              .set({
                            'name': name,
                            'study': study,
                          }).then((value) {
                            Navigator.pop(context);
                          });
                        } else {
                          Fluttertoast.showToast(msg: 'Enter all field');
                        }
                        //
                      },
                      child: Text('Add now'.toUpperCase())),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc(university)
              .collection('Departments')
              .doc(department)
              .collection('batches')
              .orderBy('name', descending: true)
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
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                //
                return GestureDetector(
                  onTap: () {
                    //
                    // Get.to(
                    //     () => UniversityDetails(university: university.name));
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 2,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ListTile(
                        title: Text(docs[index].get('name')),
                        subtitle: Text(
                          'Study: ${docs[index].get('study')}',
                        ),
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
