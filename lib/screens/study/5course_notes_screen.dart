import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '/models/chapter_model.dart';
import '/models/content_model.dart';
import '/models/course_model_new.dart';
import '/models/profile_data.dart';
import '/screens/study/uploader/content_add.dart';
import 'widgets/bookmark_counter.dart';
import 'widgets/content_card.dart';

class CourseNotesScreens extends StatefulWidget {
  const CourseNotesScreens({
    Key? key,
    required this.profileData,
    required this.selectedSemester,
    required this.selectedBatch,
    required this.courseType,
    required this.courseModel,
    required this.chapterModel,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedSemester;
  final String selectedBatch;
  final String courseType;
  final CourseModelNew courseModel;
  final ChapterModel chapterModel;
  final List<String> batches;

  @override
  State<CourseNotesScreens> createState() => _CourseNotesScreensState();
}

class _CourseNotesScreensState extends State<CourseNotesScreens> {
  // init
  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  // banner ad
  late BannerAd bannerAd;
  bool _isAdLoaded = false;
  // String adUnitId = 'ca-app-pub-3940256099942544/6300978111'; //test id
  String adUnitId = 'ca-app-pub-2392427719761726/6294434973'; //real id

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          log('ad error: ${error.message}');
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  //
  @override
  Widget build(BuildContext context) {
    var subscriber = widget.profileData.information.status!.subscriber!;
    log(subscriber);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text('${widget.chapterModel.chapterNo}. ${widget.chapterModel.chapterTitle}'),

        // bookmark
        actions: [
          // bookmark counter
          BookmarkCounter(
            profileData: widget.profileData,
            batches: widget.batches,
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: (widget.profileData.information.status!.moderator! ||
              (widget.profileData.information.status!.cr! &&
                  widget.selectedBatch == widget.profileData.information.batch))
          ? FloatingActionButton(
              onPressed: () {
                log(widget.courseType);
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddContent(
                      profileData: widget.profileData,
                      selectedSemester: widget.selectedSemester,
                      courseType: widget.courseType,
                      courseModel: widget.courseModel,
                      batches: widget.batches,
                      chapterNo: widget.chapterModel.chapterNo,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      //
      body: Column(
        children: [

          //
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Universities')
                  .doc(widget.profileData.university)
                  .collection('Departments')
                  .doc(widget.profileData.department)
                  .collection('notes')
                  .where('status', whereIn: ['basic', subscriber])
                  .where('courseCode', isEqualTo: widget.courseModel.courseCode)
                  .where('lessonNo', isEqualTo: widget.chapterModel.chapterNo)
                  .where('batches', arrayContains: widget.selectedBatch)
                  .orderBy('contentTitle')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return const Center(child: Text('No notes found!'));
                }

                var data = snapshot.data!.docs;

                //
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 16),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 1000
                        ? MediaQuery.of(context).size.width * .2
                        : 12,
                    vertical: 12,
                  ),
                  itemBuilder: (context, index) {
                    //model
                    ContentModel contentModel = ContentModel.fromJson(data[index]);
                    log('contentId: ${contentModel.contentId}');

                    //
                    return ContentCard(
                      selectedSemester: widget.selectedSemester,
                      selectedBatch: widget.selectedBatch,
                      profileData: widget.profileData,
                      contentModel: contentModel,
                      batches: widget.batches,
                    );
                  },
                );
              },
            ),
          ),

          //banner ad
          if (!kIsWeb && _isAdLoaded
          // && widget.profileData.information.status!.subscriber != 'pro'
          ) ...[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          ],
        ],
      ),
    );
  }
}
