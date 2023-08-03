import 'dart:developer';
import 'dart:io';

import 'package:campusassistant/widgets/pdf_viewer_local.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '/widgets/open_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/models/content_model.dart';
import '/models/profile_data.dart';
import '/screens/study/uploader/content_edit.dart';
import '/screens/study/widgets/bookmark_button.dart';
import '/widgets/pdf_viewer.dart';
import '/widgets/pdf_viewer_web.dart';

class ContentCard extends StatefulWidget {
  const ContentCard({
    Key? key,
    required this.profileData,
    required this.selectedSemester,
    required this.selectedBatch,
    required this.contentModel,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedSemester;
  final String selectedBatch;
  final ContentModel contentModel;
  final List<String> batches;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool _isLoading = false;
  double? _downloadProgress = 0;

  // init
  @override
  void initState() {
    super.initState();

    initInterstitialAd();
  }


  // interstitial ad
  late InterstitialAd interstitialAd;
  bool _isAdLoaded = false;

  // String adUnitId = 'ca-app-pub-3940256099942544/1033173712'; //test idF
  String adUnitId = 'ca-app-pub-2392427719761726/7253073672'; //real id

  initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          setState(() {
            _isAdLoaded = true;
          });
          interstitialAd.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            ad.dispose();

            setState(() {
              _isAdLoaded = false;
            });
            // download file
            log('start download');
          }, onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            log('ad error: ${error.message}');
          });
        },
        onAdFailedToLoad: (error) {
          interstitialAd.dispose();
          log('ad error: ${error.message}');
        },
      ),
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    List<String> batches = widget.contentModel.batches;
    batches.sort((a, b) {
      //sorting in ascending order
      return b.compareTo(a);
    });

    //
    String fileName =
        '${widget.contentModel.courseCode}-${widget.contentModel.lessonNo} ${widget.contentModel.contentTitle.replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), ' ')}_${widget.contentModel.contentSubtitle}_${widget.contentModel.contentId.toString().substring(0, 5)}.pdf';


    //
    return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 4,
            margin: const EdgeInsets.all(0),
            child: Column(
              children: [
                //

                //r1
                InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  // view pdf
                  onTap: () async {
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

                      if (File(
                              '/storage/emulated/0/Download/Campus Assistant/$fileName')
                          .existsSync()) {

                        await openFileAndroid(fileName: fileName);}
                      else {

                        //show ads
                        if (_isAdLoaded) {
                          await interstitialAd.show();

                          setState(() => _isLoading = true);

                          //
                          await downloadFileAndroid(
                            url: widget.contentModel.fileUrl,
                            fileName: fileName,
                          );

                          //
                          setState(() => _isLoading = false);
                        }else{
                          Fluttertoast.showToast(msg: 'Slow internet connection\nPlease wait & try again');
                        }

                        //
                      }


                    }
                  },

                  //edit
                  onLongPress: () {
                    if (widget.profileData.information.status!.moderator! ||
                        (widget.profileData.information.status!.cr! &&
                            widget.selectedBatch ==
                                widget.profileData.information.batch)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditContent(
                            selectedYear: widget.selectedSemester,
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
                                color:
                                    Colors.blueAccent.shade100.withOpacity(.1),
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
                                  widget.contentModel.contentType
                                              .toLowerCase() ==
                                          "notes"
                                      ? '${widget.contentModel.courseCode.toUpperCase()}: ${widget.contentModel.lessonNo}'
                                      : widget.contentModel.courseCode
                                          .toUpperCase(),
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
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                  ),
                                ),

                                const SizedBox(height: 2),

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
                                        height: 1,

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
                                          height: 1,

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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
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
                            // todo: open for now, but change later
                            // if (widget.profileData.information.status!.subscriber ==
                            //         'pro' ||
                            //     widget.profileData.information.status!.moderator! ==
                            //         true ||
                            //     widget.profileData.information.status!.cr! ==
                            //         true)

                            //if already download
                            if (File(
                                    '/storage/emulated/0/Download/Campus Assistant/$fileName')
                                .existsSync())
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: IconButton(
                                  onPressed: () async {
                                    //open file
                                    await openFileAndroid(fileName: fileName);
                                  },
                                  icon: const Icon(
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
                                          // show ad
                                          if (_isAdLoaded) {
                                            await interstitialAd.show();
                                          //load
                                          setState(() => _isLoading = true);


                                          //
                                          await downloadFileAndroid(
                                          url: widget.contentModel.fileUrl,
                                          fileName: fileName,
                                          );

                                          //
                                          setState(() => _isLoading = false);
                                          }else{
                                            Fluttertoast.showToast(msg: 'Slow internet connection\nPlease wait & try again');
                                          }

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
                                        onPressed: () async {},
                                        icon: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            //text
                                            Text(
                                              (_downloadProgress! * 100)
                                                  .toStringAsFixed(0),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: _downloadProgress == 0
                                                  ? const CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    )
                                                  : CircularProgressIndicator(
                                                      value: _downloadProgress,
                                                      strokeWidth: 2,
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
                                onPressed: () async {
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
                                tooltip: 'Preview',
                                icon: const Icon(
                                  Icons.remove_red_eye_outlined,
                                  // color: Colors.red,
                                  // size: 30,
                                ),
                              ),
                            ),

                            // bookmark
                            BookmarkButton(
                              profileData: widget.profileData,
                              contentModel: widget.contentModel,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: batches.length,
                            itemBuilder: (context, index) => Text(
                              batches[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
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

  // download file
  downloadFileAndroid({required String url, required String fileName}) async {
    //per
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not, request permission
      await Permission.storage.request();
    }

    //
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      directory = Directory("/storage/emulated/0/Download/Campus Assistant");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);

    final file = File('$exPath/$fileName');

    // download file with dio
    try {
      final response = await Dio().get(
        url,
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
      await Fluttertoast.showToast(
          msg: 'File save on: \nDownload/Campus Assistant',
          toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      log('error: $e');
      Fluttertoast.showToast(msg: 'Please wait a moment and try again! ');
    }
  }

  //open file
  openFileAndroid({required String fileName}) async {
    Directory? downloadDir =
        Directory('/storage/emulated/0/Download/Campus Assistant');
    String filePath = '${downloadDir.path}/$fileName';
    await OpenFile.open(filePath);
  }
}
