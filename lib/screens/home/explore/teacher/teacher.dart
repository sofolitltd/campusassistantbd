import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/profile_data.dart';
import '/models/teacher_model.dart';
import '/screens/home/explore/teacher/teacher_edit.dart';
import 'teacher_add.dart';
import 'teacher_details_screen.dart';

class Teacher extends StatelessWidget {
  const Teacher({
    super.key,
    required this.university,
    required this.department,
    required this.profileData,
  });

  final String university;
  final String department;
  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text('Teacher Information'),
          bottom: TabBar(
            isScrollable:
                MediaQuery.of(context).size.width > 800 ? true : false,
            tabs: const [
              Tab(text: 'Present'),
              Tab(text: 'Study Leave'),
            ],
          ),
        ),

        //body
        body: TabBarView(
          children: [
            // present
            TeacherListView(
              university: university,
              department: department,
              profileData: profileData,
              isPresent: true,
            ),

            //study leave
            TeacherListView(
              university: university,
              department: department,
              profileData: profileData,
              isPresent: false,
            ),
          ],
        ),
      ),
    );
  }
}

// teacher list view
class TeacherListView extends StatelessWidget {
  const TeacherListView({
    super.key,
    required this.university,
    required this.department,
    required this.profileData,
    required this.isPresent,
  });

  final String university;
  final String department;
  final ProfileData profileData;
  final bool isPresent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //

      floatingActionButton: profileData.information.status!.moderator!
          ? Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: FloatingActionButton(
                onPressed: () {
                  //
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherAdd(
                          profileData: profileData, present: isPresent),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            )
          : null,
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(university)
            .collection('Departments')
            .doc(department)
            .collection('Teachers')
            .where('present', isEqualTo: isPresent)
            .orderBy('serial')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;
          return snapshot.data!.size == 0
              ? const Center(child: Text('No data found'))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: .72,
                  ),
                  shrinkWrap: true,
                  itemCount: data.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width > 1000
                        ? MediaQuery.of(context).size.width * .2
                        : 16,
                    vertical: 16,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    //
                    TeacherModel teacherModel =
                        TeacherModel.formJson(data[index]);

                    //
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherDetailsScreen(
                              teacherModel: teacherModel,
                              university: university,
                              department: department,
                              profileData: profileData,
                            ),
                          ),
                        ),

                        //
                        onLongPress: () {
                          if (profileData.information.status!.moderator!) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeacherEdit(
                                  university: university,
                                  department: department,
                                  profileData: profileData,
                                  present: isPresent,
                                  teacherModel: teacherModel,
                                ),
                              ),
                            );
                          }
                        },

                        child: Column(
                          children: [
                            // img
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                //img
                                Hero(
                                  tag: teacherModel.name,
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(
                                      16,
                                      14,
                                      16,
                                      10,
                                    ),
                                    height: 140,
                                    child: CachedNetworkImage(
                                      imageUrl: teacherModel.imageUrl,
                                      fadeInDuration:
                                          const Duration(milliseconds: 500),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              8), // Apply rounded corners
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/pp_placeholder.png'),
                                          ),
                                        ),
                                        child: const Center(
                                            child:
                                                CupertinoActivityIndicator()),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/pp_placeholder.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // is chairman
                                if (teacherModel.chairman)
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.greenAccent.shade100,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 3, 8, 5),
                                    child: Text(
                                      'Chairman'.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),

                                // serial
                                if (profileData.information.status!.moderator!)
                                  Positioned(
                                    top: 12,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade200,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${teacherModel.serial}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            height: 1,
                                          )),
                                    ),
                                  ),
                              ],
                            ),

                            // const SizedBox(height: 4), // name

                            // name
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  teacherModel.name,
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                teacherModel.post,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
