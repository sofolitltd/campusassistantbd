import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HallScreen extends StatelessWidget {
  const HallScreen({Key? key, required this.university}) : super(key: key);

  final String university;

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(university)
        .collection('Halls');

    //
    String name = '';

    //
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Halls',
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
                  const Text('Add Hall'),

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
                          await ref.doc().set({
                            'name': name,
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
          stream: ref.orderBy('name').snapshots(),
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
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                //
                return Card(
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ListTile(
                      title: Text(docs[index].get('name')),
                      trailing: IconButton(
                          onPressed: () async {
                            await ref
                                .doc(docs[index].id)
                                .delete()
                                .then((value) {
                              Fluttertoast.showToast(
                                  msg: 'Delete successfully');
                            });
                          },
                          icon: const Icon(Icons.delete_outline_outlined)),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
