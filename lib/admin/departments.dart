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
    String name = '';
    String establish = '';
    String about = '';
    String imageUrl = '';
    String website = '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Departments'),
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
                  const Text('Add department'),

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

                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Establish',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    establish = val;
                  },
                ),

                const SizedBox(height: 16),

                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Image Url',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    imageUrl = val;
                  },
                ),
                const SizedBox(height: 16),

                TextField(
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    hintText: 'Website',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    website = val;
                  },
                ),

                const SizedBox(height: 16),
                TextField(
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'About',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    about = val;
                  },
                ),

                const SizedBox(height: 16),

                //
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> departmentModel = {
                          'name': name.trim(),
                          'establish': establish.trim(),
                          'imageUrl': '',
                          'website': website.trim(),
                          'about': about.trim(),
                        };

                        //
                        if (name != '' && establish != '') {
                          await FirebaseFirestore.instance
                              .collection('Universities')
                              .doc(university)
                              .collection('Departments')
                              .doc(name)
                              .set(departmentModel)
                              .then((value) {
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
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .2
                    : 16,
                vertical: 16,
              ),
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
