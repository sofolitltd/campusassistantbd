import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '/models/content_model.dart';
import '/models/course_model_new.dart';
import '/models/profile_data.dart';
import 'uploader/content_add.dart';
import 'widgets/content_card.dart';

class CourseTypesDetails extends StatefulWidget {
  const CourseTypesDetails({
    Key? key,
    required this.profileData,
    required this.selectedSemester,
    required this.selectedBatch,
    required this.courseType,
    required this.courseModel,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedSemester;
  final String selectedBatch;
  final String courseType;
  final CourseModelNew courseModel;
  final List<String> batches;

  @override
  State<CourseTypesDetails> createState() => _CourseTypesDetailsState();
}

class _CourseTypesDetailsState extends State<CourseTypesDetails> {
  // init
  @override
  void initState() {
    super.initState();
    initBannerAd();
  }

  // banner ad
  BannerAd? bannerAd;
  // bool _isAdLoaded = false;
  // String adUnitId = 'ca-app-pub-3940256099942544/6300978111'; //test id
  String adUnitId = 'ca-app-pub-2392427719761726/6294434973'; //real id

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // setState(() {
          //   _isAdLoaded = true;
          // });
          log('ad load: ${ad.adUnitId}');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          log('ad error: ${error.message}');
        },
      ),
      request: const AdRequest(),
    );
    bannerAd!.load();
  }

  //
  @override
  Widget build(BuildContext context) {
    var subscriber = widget.profileData.information.status!.subscriber;

    return Scaffold(
      // add content
      floatingActionButton: (widget.profileData.information.status!.moderator! ||
              (widget.profileData.information.status!.cr! &&
                  widget.selectedBatch == widget.profileData.information.batch))
          ? FloatingActionButton(
              onPressed: () {
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
                  .collection(widget.courseType.toLowerCase())
                  .where('status', whereIn: ['basic', subscriber])
                  .where('courseCode', isEqualTo: widget.courseModel.courseCode)
                  .where('batches', arrayContains: widget.selectedBatch)
                  // .where('lessonNo', isEqualTo: courseType.lessonNo)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return Center(child: Text('No ${widget.courseType} Found!'));
                }

                var data = snapshot.data!.docs;

                //
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: data.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 12),
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 1000
                        ? MediaQuery.of(context).size.width * .2
                        : 12,
                    vertical: 12,
                  ),
                  itemBuilder: (context, index) {
                    //model
                    ContentModel courseContentModel =
                        ContentModel.fromJson(data[index]);

                    //
                    return ContentCard(
                      profileData: widget.profileData,
                      selectedSemester: widget.selectedSemester,
                      selectedBatch: widget.selectedBatch,
                      contentModel: courseContentModel,
                      batches: widget.batches,
                    );
                  },
                );
              },
            ),
          ),

          //banner ad
          if (!kIsWeb &&
          bannerAd != null
              // _isAdLoaded
          // && widget.profileData.information.status!.subscriber != 'pro'
          ) ...[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: bannerAd!.size.height.toDouble(),
              width: bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: bannerAd!),
            )
          ],
        ],
      ),
    );
  }
}
