//
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';

import '../../../../widgets/open_app.dart';
import '../../../study/widgets/pdf_viewer_web.dart';

class SyllabusCardWeb extends StatefulWidget {
  const SyllabusCardWeb({Key? key, required this.contentData}) : super(key: key);
  final DocumentSnapshot contentData;

  @override
  State<SyllabusCardWeb> createState() => _SyllabusCardWebState();
}

class _SyllabusCardWebState extends State<SyllabusCardWeb> {

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.zero,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          OpenApp.openPdf(widget.contentData.get('fileUrl'));

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            Text(
              'Sessions',
              style: Theme.of(context).textTheme.labelMedium,
            ),

            //
            Text(
              widget.contentData.get('contentTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),


            const SizedBox(height: 8),

            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // preview
                SizedBox(
                  height: 40,
                  width: 40,
                  child: IconButton(
                    tooltip: 'Preview file',
                    onPressed: () {
                      //
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewerWeb(
                            contentTitle: widget.contentData.get('contentTitle'),
                            fileUrl: widget.contentData.get('fileUrl'),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.visibility_outlined,
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

}
