//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/chapter_model.dart';
import '../../models/course_model.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../widgets/open_app.dart';
import 'upload/add_video.dart';

class CourseVideos extends StatelessWidget {
  const CourseVideos({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    this.courseChapterModel,
    required this.courseModel,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final ChapterModel? courseChapterModel;
  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // add videos
      floatingActionButton: (userModel.role[UserRole.cr.name])
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddVideo(
                      userModel: userModel,
                      selectedYear: selectedYear,
                      id: id,
                      courseModel: courseModel,
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
              .doc(userModel.university)
              .collection('Departments')
              .doc(userModel.department)
              .collection('Videos')
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
              shrinkWrap: true,
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

                  // todo: check later
                  onLongPress: () async {
                    //del
                    await FirebaseFirestore.instance
                        .collection('Universities')
                        .doc(userModel.university)
                        .collection('Departments')
                        .doc(userModel.department)
                        .collection('Videos')
                        .doc(data[index].id)
                        .delete();
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          //
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              child: Image.network(
                                thumb,
                                fit: BoxFit.cover,
                                height: 100,
                              ),
                            ),
                          ),

                          //
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            .titleMedium,
                                      ),
                                    ],
                                  ),

                                  // title sub
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //
                                      Text(
                                        'Subtitle',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(color: Colors.grey),
                                      ),

                                      //sub
                                      Text(
                                        data[index].get('subtitle'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
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
                );
              },
            );
          }),
    );
  }
}
