//
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';

import '../../../study/widgets/pdf_viewer_web.dart';

class SyllabusCard extends StatefulWidget {
  const SyllabusCard({Key? key, required this.contentData}) : super(key: key);
  final DocumentSnapshot contentData;

  @override
  State<SyllabusCard> createState() => _SyllabusCardState();
}

class _SyllabusCardState extends State<SyllabusCard> {
  bool _isLoading = false;
  double? _downloadProgress;

  @override
  Widget build(BuildContext context) {
    String fileName =
        // '${widget.contentData.get('contentTitle')}_${widget.contentData.id.toString().substring(0, 5)}.pdf';
        '${widget.contentData.get('contentTitle').replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), ' ')}_${widget.contentData.id.toString().substring(0, 5)}.pdf';

    return Card(
      margin: EdgeInsets.zero,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          //
          final appStorage =
              Directory('/storage/emulated/0/Download/Campus Assistant');

          //
          final file = File('${appStorage.path}/$fileName');

          //
          if (file.existsSync()) {
            log('exist: ${file.path}');
            await OpenFile.open(file.path);
          } else {
            log('not exist');

            //
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Download File!'),
                content: const Text(
                    'First time you should download this file to open.'),
                contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                actions: [
                  //cancel
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),

                  //download
                  TextButton(
                      onPressed: () async {
                        setState(() => _isLoading = true);

                        //
                        Navigator.pop(context);

                        //
                        await downloadAndOpenFile(
                            url: widget.contentData.get('fileUrl'),
                            fileName: fileName);

                        setState(() => _isLoading = false);
                      },
                      child: const Text('Download')),
                ],
              ),
            );
          }
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
                // download button
                if (downloadFileChecker(fileName: fileName))
                  const SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        // size: 30,
                      ),
                    ),
                  )
                else
                  (_isLoading == false)
                      ? SizedBox(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            onPressed: () async {
                              setState(() => _isLoading = true);

                              //
                              await downloadFile(
                                widget.contentData.get('fileUrl'),
                                fileName,
                              );

                              //
                              setState(() => _isLoading = false);
                            },
                            icon: const Icon(
                              Icons.downloading_rounded,
                              color: Colors.red,
                              // size: 30,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            onPressed: () async {
                              //

                              // cancelToken.cancel();
                            },
                            icon: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(
                                  // Icons.clear,
                                  Icons.downloading_rounded,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    value: _downloadProgress,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

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
                            contentTitle:
                                widget.contentData.get('contentTitle'),
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

  // downloadFileChecker
  downloadFileChecker({required String fileName}) {
    final appStorage =
        Directory('/storage/emulated/0/Download/Campus Assistant');

    final file = File('${appStorage.path}/$fileName');

    if (file.existsSync()) {
      return true;
    }
    return false;
  }

// downloadAndOpenFile
  downloadAndOpenFile({required String url, required String fileName}) async {
    // download file
    final file = await downloadFile(url, fileName);

    //
    if (file == null) return;
    log('path:  $file');
    OpenFile.open(file.path);
  }

// download file
  Future<File?> downloadFile(String url, String fileName) async {
    // file location
    // final appStorage = await getApplicationDocumentsDirectory();
    final appStorage =
        await Directory('/storage/emulated/0/Download/Campus Assistant')
            .create(recursive: true);
    final file = File('${appStorage.path}/$fileName');

    // download file with dio
    try {
      final response = await Dio().get(url,
          // cancelToken: cancelToken,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ), onReceiveProgress: (received, total) {
        double progress = received / total;
        setState(() {
          _downloadProgress = progress;
        });
      });

      // store on file system
      final ref = file.openSync(mode: FileMode.write);
      ref.writeFromSync(response.data);
      await ref.close();

      //
      Fluttertoast.showToast(msg: 'File save on /Download/Campus Assistant');

      return file;
    } catch (e) {
      log('dio error: $e');
      return null;
    }
  }
}
