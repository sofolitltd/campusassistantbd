import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '/models/content_model.dart';
import 'pdf_viewer_web.dart';

class ContentCard extends StatefulWidget {
  const ContentCard({
    Key? key,
    // required this.userModel,
    required this.courseContentModel,
  }) : super(key: key);

  // final UserModel userModel;
  final ContentModel courseContentModel;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool _isLoading = false;
  double? _downloadProgress;
  CancelToken cancelToken = CancelToken();
  bool permissionGranted = false;

  //
  final ReceivePort _port = ReceivePort();

  @override
  Widget build(BuildContext context) {
    // String fileName =
    // String fileNameTemp =
    //     '${widget.courseContentModel.courseCode}_${widget.courseContentModel.contentTitle.replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), ' ')}_${widget.courseContentModel.contentSubtitle}_${widget.courseContentModel.contentId.toString().substring(0, 5)}.pdf';
    String fileName = '${widget.courseContentModel.contentId}.pdf';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          // todo
          ListTile(
            // onLongPress: (widget.userModel.role[UserRole.cr.name] ||
            //         widget.userModel.role[UserRole.admin.name])
            //     ? () {
            //         //
            //         showDialog(
            //           context: context,
            //           builder: (context) => AlertDialog(
            //             title: const Text('File Management'),
            //             actions: [
            //               //
            //               TextButton(
            //                   onPressed: () async {
            //                     //
            //                     var url = widget.courseContentModel.fileUrl;
            //                     await FirebaseStorage.instance
            //                         .refFromURL(url)
            //                         .delete();
            //
            //                     //
            //                     FirebaseFirestore.instance
            //                         .collection('Universities')
            //                         .doc(widget.userModel.university)
            //                         .collection('Departments')
            //                         .doc(widget.userModel.department)
            //                         .collection(
            //                             widget.courseContentModel.contentType)
            //                         .doc(widget.courseContentModel.contentId)
            //                         .delete();
            //
            //                     if (!mounted) return;
            //                     Navigator.pop(context);
            //                   },
            //                   child: const Text('Delete')),
            //
            //               //
            //               TextButton(
            //                   onPressed: () {
            //                     Navigator.pushReplacement(
            //                       context,
            //                       MaterialPageRoute(
            //                         builder: (context) => EditContent(
            //                           userModel: widget.userModel,
            //                           courseContentModel:
            //                               widget.courseContentModel,
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                   child: const Text('Edit')),
            //             ],
            //           ),
            //         );
            //       }
            //     : null,
            onTap: () async {
              //
              // final appStorage = await getApplicationDocumentsDirectory();
              final appStorage =
                  Directory('/storage/emulated/0/Download/Campus Assistant');

              final file = File('${appStorage.path}/$fileName');

              //
              if (file.existsSync()) {
                print('exist: ${file.path}');
                await OpenFile.open(file.path);
              } else {
                print('not exist');

                //
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Download File!'),
                    content: const Text(
                        'First time you should  download this file to open.'),
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
                                url: widget.courseContentModel.fileUrl,
                                fileName: fileName);

                            setState(() => _isLoading = false);
                          },
                          child: const Text('Download')),
                    ],
                  ),
                );
              }
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            // horizontalTitleGap: 8,
            leading: Stack(
              alignment: Alignment.topLeft,
              children: [
                //
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.courseContentModel.imageUrl == ''
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 56),
                          child: Image.asset(
                            'assets/images/placeholder.jpg',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.network(
                          widget.courseContentModel.imageUrl,
                          fit: BoxFit.cover,
                        ),
                ),

                //
                if (widget.courseContentModel.status == 'Pro')
                  const Icon(
                    Icons.workspace_premium_outlined,
                    color: Colors.blue,
                    size: 20,
                  )
              ],
            ),
            title: Text(
              widget.courseContentModel.contentTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, height: 1),
            ),
            subtitle: Text.rich(
              TextSpan(
                text: '${widget.courseContentModel.contentSubtitleType}:  ',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 12,
                    ),
                children: [
                  TextSpan(
                    text: widget.courseContentModel.contentSubtitle,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(),
                  )
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Divider(height: 1),

          //
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 4, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // r1
                Row(
                  children: [
                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Code:',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.grey),
                        ),

                        //time
                        Text(widget.courseContentModel.courseCode,
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                      child: VerticalDivider(thickness: 1),
                    ),

                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload on:',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.grey),
                        ),

                        //time
                        Text(widget.courseContentModel.uploadDate,
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                      child: VerticalDivider(thickness: 1),
                    ),

                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload by:',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.grey),
                        ),

                        //uploader
                        Text(widget.courseContentModel.uploader,
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ],
                ),

                //r2
                Row(
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
                                      widget.courseContentModel.fileUrl,
                                      fileName);

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
                                    widget.courseContentModel.contentTitle,
                                fileUrl: widget.courseContentModel.fileUrl,
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
          ),
        ],
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
    print('path:  $file');
    OpenFile.open(file.path);
  }

// download file
//   Future<File?> downloadFile(String url, String fileName) async {
//     // file location
//     // final appStorage = await getApplicationDocumentsDirectory();
//     final appStorage =
//         await Directory('/storage/emulated/0/Download/Campus Assistant')
//             .create(recursive: true);
//     final file = File('${appStorage.path}/$fileName');
//
//     // download file with dio
//     try {
//       final response = await Dio().get(url,
//           // cancelToken: cancelToken,
//           options: Options(
//             responseType: ResponseType.bytes,
//             followRedirects: false,
//             receiveTimeout: 0,
//           ), onReceiveProgress: (received, total) {
//         double progress = received / total;
//         setState(() {
//           _downloadProgress = progress;
//         });
//       });
//
//       // store on file system
//       final ref = file.openSync(mode: FileMode.write);
//       ref.writeFromSync(response.data);
//       await ref.close();
//
//       //
//       Fluttertoast.showToast(msg: 'File save on /Download/Campus Assistant');
//
//       return file;
//     } catch (e) {
//       print('dio error: $e');
//       Fluttertoast.showToast(msg: e.toString());
//       return null;
//     }
//   }

  // download file
  Future<File?> downloadFile(String url, String fileName) async {
    // file location
    final Directory appStorage = await getApplicationSupportDirectory();
    // print('storage: $appStorage');

    // final Directory appStorage =
    // await Directory('/storage/emulated/0/Download').create(recursive: true);
    final file = File('${appStorage.path}/$fileName');

    // download file with dio
    try {
      // final response = await Dio().get(url,
      //     // cancelToken: cancelToken,
      //     options: Options(
      //       responseType: ResponseType.bytes,
      //       followRedirects: false,
      //       receiveTimeout: 0,
      //     ), onReceiveProgress: (received, total) {
      //   double progress = received / total;
      //   setState(() {
      //     _downloadProgress = progress;
      //   });
      // });
      //
      // // store on file system
      // final ref = file.openSync(mode: FileMode.write);
      // ref.writeFromSync(response.data);
      // await ref.close();

      // start download

      //
      Fluttertoast.showToast(msg: 'File downloaded');

      return file;
    } catch (e) {
      print('error: $e');
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }
}
