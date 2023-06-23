import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/pdf_viewer_web.dart';

class SyllabusCardWeb extends StatefulWidget {
  const SyllabusCardWeb({Key? key, required this.contentData})
      : super(key: key);
  final DocumentSnapshot contentData;

  @override
  State<SyllabusCardWeb> createState() => _SyllabusCardWebState();
}

class _SyllabusCardWebState extends State<SyllabusCardWeb> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerWeb(
              title: widget.contentData.get('contentTitle'),
              fileUrl: widget.contentData.get('fileUrl'),
            ),
          ),
        );
      },

      //
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
          child: Column(
            children: [
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //title
                  Text(
                    'Sessions',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),

                  //
                  Text(
                    widget.contentData.get('contentTitle'),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //time
                  Container(
                    padding: const EdgeInsets.fromLTRB(6, 4, 10, 4),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.watch_later_outlined,
                          color: Colors.black,
                          size: 16,
                        ),

                        const SizedBox(width: 5),

                        // time
                        Text(
                          widget.contentData.get('uploadDate'),
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
