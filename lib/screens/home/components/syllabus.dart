import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../widgets/headline.dart';

class Syllabus extends StatelessWidget {
  const Syllabus({Key? key}) : super(key: key);

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
            child: Headline(title: 'Syllabus'),
          ),

          //
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Study')
                .doc('Syllabus')
                .collection('All Batch')
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
                padding: const EdgeInsets.symmetric(vertical: 8),
                height: 115,
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
                    return InkWell(
                      onTap: () {
                        if (fileUrl.isNotEmpty) {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => PdfViewScreen(
                          //             fileUrl: fileUrl,
                          //             title: 'Syllabus ($title)')));
                        } else {
                          Fluttertoast.showToast(msg: 'File not upload yet');
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: .5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(minWidth: 88),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              minRadius: 24,
                              backgroundColor:
                                  Colors.pink.shade100.withOpacity(.5),
                              child: Image.asset(
                                'assets/logo/pdf.png',
                                height: 48,
                              ),
                            ),

                            const SizedBox(height: 8),
                            //
                            Text(
                              title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
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
