import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '/models/chapter_model.dart';
import '/models/course_model_new.dart';
import '/models/profile_data.dart';
import '/screens/study/upload/video_add.dart';
import '/widgets/open_app.dart';

class CourseVideos extends StatelessWidget {
  const CourseVideos({
    Key? key,
    required this.profileData,
    required this.selectedYear,
    this.courseChapterModel,
    required this.courseModel,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedYear;
  final ChapterModel? courseChapterModel;
  final CourseModelNew courseModel;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (profileData.information.status!.moderator! ||
              profileData.information.status!.cr!)
          ? FloatingActionButton(
              onPressed: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddVideo(
                      profileData: profileData,
                      selectedYear: selectedYear,
                      courseModel: courseModel,
                      batches: batches,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Universities')
              .doc(profileData.university)
              .collection('Departments')
              .doc(profileData.department)
              .collection('videos')
              .where('courseCode', isEqualTo: courseModel.courseCode)
              .orderBy('chapterNo')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.size == 0) {
              return const Center(child: Text('No videos found!'));
            }

            var data = snapshot.data!.docs;

            //
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                var url = YoutubePlayer.convertUrlToId(data[index].get('url'));

                var thumb = YoutubePlayer.getThumbnail(videoId: url.toString());
                //
                return GestureDetector(
                  onTap: () async {
                    OpenApp.withUrl(data[index].get('url').toString());
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Row(
                          children: [
                            //
                            SizedBox(
                              height: 100,
                              width: 125,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                child: Image.network(
                                  thumb,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            //
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //
                                        Text(
                                          'Title',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(color: Colors.grey),
                                        ),

                                        //
                                        Text(
                                          '${data[index].get('chapterNo')}. '
                                          '${data[index].get('title')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ],
                                    ),

                                    // title sub
                                    Text(
                                      data[index].get('subtitle'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        //
                        if (profileData.information.status!.moderator! ||
                            profileData.information.status!.cr!) ...[
                          IconButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('Universities')
                                  .doc(profileData.university)
                                  .collection('Departments')
                                  .doc(profileData.department)
                                  .collection('videos')
                                  .doc(data[index].id)
                                  .delete()
                                  .then((value) {
                                Fluttertoast.showToast(
                                    msg: 'Delete successfully');
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
