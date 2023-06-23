import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/course_model_new.dart';
import '/models/profile_data.dart';
import '/screens/study/uploader/course_edit.dart';
import '/screens/study/widgets/course_info.dart';
import '../3course_type_screen.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    Key? key,
    required this.profileData,
    required this.selectedSemester,
    required this.selectedBatch,
    required this.courseId,
    required this.courseModel,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedSemester;
  final String selectedBatch;
  final String courseId;
  final CourseModelNew courseModel;
  final List<String> batches;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          //
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseTypeScreen(
                profileData: profileData,
                selectedSemester: selectedSemester,
                selectedBatch: selectedBatch,
                courseModel: courseModel,
                batches: batches,
              ),
            ),
          );
        },
        onLongPress: () {
          if (profileData.information.status!.moderator! == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditCourse(
                  profileData: profileData,
                  courseModel: courseModel,
                  selectedSemester: selectedSemester,
                  courseId: courseId,
                  batches: batches,
                ),
              ),
            );
          }
        },

        //
        child: SizedBox(
          height: 140,
          child: Row(
            children: [
              //
              Expanded(
                flex: 1,
                child: CachedNetworkImage(
                  imageUrl: courseModel.image,
                  fadeInDuration: const Duration(milliseconds: 500),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/placeholder.jpg'),
                        // fit: BoxFit.,
                      ),
                    ),
                  ),
                ),
              ),

              //
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Course Title',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                          Container(
                            constraints: const BoxConstraints(minHeight: 48),
                            padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * .12,
                            ),
                            child: Text(
                              courseModel.courseTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    // letterSpacing: 0,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      //
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          courseInfo(
                            context,
                            title: 'Course Code',
                            value: courseModel.courseCode,
                          ),
                          courseInfo(
                            context,
                            title: 'Marks',
                            value: courseModel.courseMarks,
                          ),
                          courseInfo(
                            context,
                            title: 'Credits',
                            value: courseModel.courseCredits,
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
  }
}
