import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClubDetails extends StatelessWidget {
  const ClubDetails({Key? key, required this.data}) : super(key: key);

  final QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.get('name')),
        centerTitle: true,
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: data.reference.collection('members').orderBy('id').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size == 0) {
            return const Center(child: Text('No data Found!'));
          }

          var data = snapshot.data!.docs;

          //
          return ListView.separated(
            itemCount: data.length,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width * .2
                  : 12,
              vertical: 12,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              //for mobile
              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: data[index].get('image') != ''
                      ? CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                            data[index].get('image'),
                          ),
                        )
                      : CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade50,
                        ),
                  title: Text(
                    data[index].get('name'),
                  ),
                  subtitle: Text(
                    data[index].get('designation'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
