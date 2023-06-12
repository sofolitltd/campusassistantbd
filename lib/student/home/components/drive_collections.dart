import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../widgets/headline.dart';
import '../widgets/link_card.dart';

class DriveCollections extends StatelessWidget {
  const DriveCollections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //category title
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Headline(title: 'Google Drive links'),
          ),

          //
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Study')
                .doc('Drives')
                .collection('All Drives')
                .orderBy('year')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              var data = snapshot.data!.docs;

              //
              return Container(
                margin: const EdgeInsets.only(left: 8),
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    String title = data[index].get('year');
                    String fileUrl = data[index].get('fileUrl');
                    //
                    return ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 88),
                      child: LinkCard(
                        title: title,
                        link: fileUrl,
                        imageUrl: 'assets/logo/google_drive.png',
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
