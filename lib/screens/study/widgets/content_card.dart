import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '/models/content_model.dart';
import '/models/profile_data.dart';
import '/screens/study/upload/content_edit.dart';
import '/screens/study/widgets/bookmark_button.dart';
import '/screens/study/widgets/pdf_viewer_web.dart';
import '/widgets/pdf_viewer.dart';

class ContentCard extends StatefulWidget {
  const ContentCard({
    Key? key,
    required this.selectedYear,
    required this.profileData,
    required this.contentModel,
    required this.batches,
  }) : super(key: key);

  final String selectedYear;
  final ProfileData profileData;
  final ContentModel contentModel;
  final List<String> batches;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool _isLoading = false;
  double? _downloadProgress;
  String? directoryPath;

  @override
  void initState() {
    super.initState();
    getPublicDirectoryPath();
  }

  Future<void> getPublicDirectoryPath() async {
    if (!kIsWeb) {
      directoryPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOCUMENTS);

      log(directoryPath.toString()); // /storage/emulated/0/Download
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String fileName =
        '${widget.contentModel.courseCode}_${widget.contentModel.contentTitle.replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), ' ')}_${widget.contentModel.contentSubtitle}_${widget.contentModel.contentId.toString().substring(0, 5)}.pdf';

    List<String> batches = widget.contentModel.batches;
    batches.sort((a, b) {
      //sorting in ascending order
      return b.compareTo(a);
    });

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          //r1
          InkWell(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            // view pdf
            onTap: () {
              if (kIsWeb) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerWeb(
                      title: widget.contentModel.contentTitle,
                      fileUrl: widget.contentModel.fileUrl,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewer(
                      title: widget.contentModel.contentTitle,
                      fileUrl: widget.contentModel.fileUrl,
                    ),
                  ),
                );
              }
            },

            //delete
            onLongPress: () {
              if (widget.profileData.information.status!.moderator! ||
                  widget.profileData.information.status!.cr!) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditContent(
                      selectedYear: widget.selectedYear,
                      profileData: widget.profileData,
                      contentModel: widget.contentModel,
                      batches: widget.batches,
                    ),
                  ),
                );
              }
            },

            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // image
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      //
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          width: 72,
                          height: 72,
                          color: Colors.blueAccent.shade100.withOpacity(.1),
                          child: widget.contentModel.imageUrl == ''
                              ? SizedBox(
                                  child: Image.asset(
                                    'assets/images/placeholder.jpg',
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Image.network(
                                  widget.contentModel.imageUrl,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),

                      //
                      if (widget.contentModel.status == 'pro')
                        const Icon(
                          Icons.workspace_premium_outlined,
                          color: Colors.blue,
                          size: 24,
                        )
                    ],
                  ),

                  const SizedBox(width: 10),

                  //
                  Expanded(
                    child: SizedBox(
                      height: 72,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //code
                          Text(
                            widget.contentModel.contentType.toLowerCase() ==
                                    "notes"
                                ? '${widget.contentModel.courseCode.toUpperCase()}: ${widget.contentModel.lessonNo}'
                                : widget.contentModel.courseCode.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                          ),

                          const SizedBox(height: 1),

                          //title
                          Text(
                            widget.contentModel.contentTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold, height: 1.2),
                          ),

                          const SizedBox(height: 4),

                          // const Spacer(),

                          // creator/writer
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.contentModel.contentSubtitleType}:  ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 12,
                                    ),
                              ),
                              Flexible(
                                child: Text(
                                  widget.contentModel.contentSubtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),
          const SizedBox(height: 4),

          //r2
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 4, 4),
            child: Stack(
              children: [
                //on, by
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // on
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload on: ',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 12,
                                  ),
                        ),

                        //time
                        Text(
                          widget.contentModel.uploadDate,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(),
                        ),
                      ],
                    ),
                    //
                    const SizedBox(
                      height: 24,
                      width: 20,
                      child: VerticalDivider(thickness: 1),
                    ),

                    // by
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload by:',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12),
                        ),

                        //uploader
                        Text(
                          widget.contentModel.uploader,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(),
                        ),
                      ],
                    ),

                    //
                    const Spacer(),
                  ],
                ),

                // download, view , bookmark
                Positioned(
                  right: 0,
                  bottom: -6,
                  child: Row(
                    children: [
                      // download //todo: add later[add cr, moderator also]
                      if (!kIsWeb &&
                          widget.profileData.information.status!.admin!) ...[
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
                                        url: widget.contentModel.fileUrl,
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
                        // preview
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            tooltip: 'Preview  before download or open file',
                            onPressed: () {
                              //
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfViewerWeb(
                                    title: widget.contentModel.contentTitle,
                                    fileUrl: widget.contentModel.fileUrl,
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

                      //
                      BookmarkButton(
                        profileData: widget.profileData,
                        courseContentModel: widget.contentModel,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // batches
          if (widget.profileData.information.status!.moderator! ||
              widget.profileData.information.status!.cr!) ...[
            // const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              height: 20,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_right,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),

                  //list
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Text(
                        ' , ',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 12,
                              height: 1.4,
                            ),
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: batches.length,
                      itemBuilder: (context, index) => Text(
                        batches[index],
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 12,
                              height: 1.4,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
          ],
        ],
      ),
    );
  }

  // downloadFileChecker
  downloadFileChecker({required String fileName}) {
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
