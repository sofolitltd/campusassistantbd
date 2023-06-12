import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '/models/student_model.dart';
import '../../../../admin/student_add.dart';
import '../../../../models/profile_data.dart';
import '../../../../student/home/student/widgets/student_card.dart';
import '../../../../widgets/open_app.dart';
import 'all_student_screen.dart';

class UserBatchScreen extends StatelessWidget {
  // static const routeName = '/student';

  const UserBatchScreen({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        // centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
        actions: [
          // all batch
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: MaterialButton(
                color: Colors.pink[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () async {
                  //
                  Get.toNamed(
                    AllStudentScreen.routeName,
                    arguments: {
                      'profileData': profileData,
                    },
                  );
                },
                child: const Text('All Students',
                    style: TextStyle(color: Colors.black87))),
          )
        ],
      ),

      // add student
      floatingActionButton: (profileData.information.status!.cr! == false)
          ? null
          : FloatingActionButton(
              onPressed: () {
                Get.to(
                  () => AddStudent(
                    university: profileData.university,
                    department: profileData.department,
                    selectedBatch: profileData.information.batch!,
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(profileData.university)
            .collection('Departments')
            .doc(profileData.department)
            .collection('Students')
            .doc('Batches')
            .collection(profileData.information.batch!)
            .orderBy('orderBy', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(child: Text('No data found!'));
          }

          //
          return Scrollbar(
            radius: const Radius.circular(8),
            interactive: true,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .2
                    : 16,
                vertical: 16,
              ),
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int index) {
                StudentModel studentModel = StudentModel.fromJson(data[index]);

                //
                return StudentCard(
                  profileData: profileData,
                  studentModel: studentModel,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

//
class StudentCard extends StatelessWidget {
  final ProfileData profileData;
  final StudentModel studentModel;

  const StudentCard({
    Key? key,
    required this.profileData,
    required this.studentModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          //
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullImage(
                                  title: studentModel.name,
                                  imageUrl: studentModel.imageUrl)));
                    },
                    child: CachedNetworkImage(
                      height: 88,
                      width: 88,
                      fit: BoxFit.cover,
                      imageUrl: studentModel.imageUrl,
                      fadeInDuration: const Duration(milliseconds: 500),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/pp_placeholder.png',
                          // fit: BoxFit.cover,
                          width: 88,
                          height: 88,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                //info, call
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 88,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        //
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //name
                            Text(
                              studentModel.name,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),

                            //id, blood
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //id
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Student ID',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(),
                                    ),
                                    Text(
                                      studentModel.id,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),

                                if (studentModel.blood.isNotEmpty)
                                  const SizedBox(
                                    height: 32,
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                      width: 24,
                                    ),
                                  ),

                                if (studentModel.blood.isNotEmpty)
                                  // blood
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //id
                                      Text(
                                        'Blood ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(),
                                      ),
                                      Text(
                                        studentModel.blood,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red,
                                            ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),

                            const SizedBox(height: 2),

                            //hall
                            if ((studentModel.hall != 'None'))
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hall',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(),
                                  ),
                                  Text(
                                    studentModel.hall,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                          ],
                        ),

                        //call
                        if (studentModel.phone.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: IconButton(
                              onPressed: () async {
                                await OpenApp.withNumber(studentModel.phone);
                              },
                              icon: const Icon(
                                Icons.call,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
