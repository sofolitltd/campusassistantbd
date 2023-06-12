import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '/student/study/widgets/pdf_viewer_web.dart';
import '/widgets/pdf_viewer.dart';

class SyllabusCard extends StatefulWidget {
  const SyllabusCard({Key? key, required this.contentData}) : super(key: key);
  final DocumentSnapshot contentData;

  @override
  State<SyllabusCard> createState() => _SyllabusCardState();
}

class _SyllabusCardState extends State<SyllabusCard> {
  bool _isLoading = false;
  double? _downloadProgress;
  String? directoryPath;

  @override
  void initState() {
    super.initState();
    getPublicDirectoryPath();
  }

  Future<void> getPublicDirectoryPath() async {
    directoryPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS);

    log(directoryPath.toString()); // /storage/emulated/0/Download
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String fileName =
        '${widget.contentData.get('contentTitle').replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), ' ')}_${widget.contentData.id.toString().substring(0, 5)}.pdf';

    return GestureDetector(
      onTap: () {
        Get.to(
          () => PdfViewer(
            title: widget.contentData.get('contentTitle'),
            fileUrl: widget.contentData.get('fileUrl'),
          ),
        );
      },

      //
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 4),
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

                  // btn
                  Row(
                    children: [
                      //
                      Row(
                        children: [
                          //todo: download button
                          if (directoryPath != null &&
                              downloadFileChecker(fileName: fileName))
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
                                        await downloadFileAndroid(
                                          url:
                                              widget.contentData.get('fileUrl'),
                                          fileName: fileName,
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

                          //
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
                                      contentTitle: widget.contentData
                                          .get('contentTitle'),
                                      fileUrl:
                                          widget.contentData.get('fileUrl'),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.visibility_outlined,
                              ),
                            ),
                          ),

                          // fav
                          // BookmarkButton(
                          //   userModel: widget.userModel,
                          //   courseContentModel: widget.courseContentModel,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// downloadFileChecker
  downloadFileChecker({required String fileName}) {
    final appStorage = directoryPath!;
    final file = File('$directoryPath/$fileName');

    if (file.existsSync()) {
      return true;
    }
    return false;
  }

  Future<bool> getStoragePermission() async {
    return await Permission.storage.request().isGranted;
  }

  // download file
  Future<File?> downloadFileAndroid(
      {required String url, required String fileName}) async {
    if (await getStoragePermission()) {
      final file = File('$directoryPath/$fileName');

      // download file with dio
      try {
        final response = await Dio().get(
          url,
          // cancelToken: cancelToken,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ),
          onReceiveProgress: (received, total) {
            double progress = received / total;
            _downloadProgress = progress;
            setState(() {});
          },
        );

        // store on file system
        final ref = file.openSync(mode: FileMode.write);
        ref.writeFromSync(response.data);
        await ref.close();
        Fluttertoast.showToast(msg: 'File save on: \n$directoryPath');

        return file;
      } catch (e) {
        log('error: $e');
        Fluttertoast.showToast(msg: e.toString());
      }
    }
    return null;
  }
}
