import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/screens/home/teacher/teacher_add.dart';
import '/screens/home/teacher/teachers_edit.dart';
import '../../../models/teacher_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/constants.dart';
import '../teacher/teacher_details_screen.dart';

class TeacherScreen extends StatelessWidget {
  static const routeName = '/teacher';

  const TeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

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
            TeacherListView(userModel: userModel, isPresent: true),

            //study leave
            TeacherListView(userModel: userModel, isPresent: false),
          ],
        ),
      ),
    );
  }
}

// teacher list view
class TeacherListView extends StatelessWidget {
  const TeacherListView(
      {Key? key, required this.userModel, required this.isPresent})
      : super(key: key);

  final UserModel userModel;
  final bool isPresent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: userModel.role[UserRole.admin.name]
          ? Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: FloatingActionButton(
                onPressed: () {
                  //
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TeacherAdd(userModel: userModel, present: isPresent),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(userModel.university)
            .collection('Departments')
            .doc(userModel.department)
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
              : Scrollbar(
                  radius: const Radius.circular(8),
                  interactive: true,
                  child: ListView.separated(
                    // shrinkWrap: true,
                    itemCount: data.length,

                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 1000
                          ? MediaQuery.of(context).size.width * .2
                          : 16,
                      vertical: 16,
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
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
                        child: ListTile(
                          horizontalTitleGap: 8,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          trailing: userModel.role[UserRole.admin.name]
                              ? PopupMenuButton(
                                  itemBuilder: (context) => [
                                    //delete
                                    PopupMenuItem(
                                        value: 1,
                                        onTap: () {
                                          //
                                          Future(
                                            () =>
                                                //
                                                Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TeacherEdit(
                                                  userModel: userModel,
                                                  teacherModel: teacherModel,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Edit')),

                                    //delete
                                    PopupMenuItem(
                                        value: 2,
                                        onTap: () async {
                                          //delete
                                          await FirebaseFirestore.instance
                                              .collection('Universities')
                                              .doc(userModel.university)
                                              .collection('Departments')
                                              .doc(userModel.department)
                                              .collection('Teachers')
                                              .doc(teacherModel.id)
                                              .delete()
                                              .then((value) {
                                            Fluttertoast.showToast(
                                                msg: 'Successfully deleted');
                                          });
                                        },
                                        child: const Text('Delete')),
                                  ],
                                )
                              : null,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherDetailsScreen(
                                teacherModel: teacherModel,
                                userModel: userModel,
                              ),
                            ),
                          ),

                          leading: Hero(
                            tag: teacherModel.name,
                            child: CachedNetworkImage(
                              imageUrl: teacherModel.imageUrl,
                              fadeInDuration: const Duration(milliseconds: 500),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 32,
                              ),
                              progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                  const CircleAvatar(
                                      radius: 32,
                                      backgroundImage: AssetImage(
                                          'assets/images/pp_placeholder.png'),
                                      child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                      radius: 32,
                                      backgroundImage: AssetImage(
                                          'assets/images/pp_placeholder.png')),
                            ),
                          ),

                          //
                          title: Row(
                            children: [
                              //
                              if (userModel.role[UserRole.admin.name])
                                Text('${teacherModel.serial}. '),
                              //
                              Flexible(
                                child: Text(
                                  teacherModel.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          //
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //post
                              Text(teacherModel.post, style: const TextStyle()),

                              // is chairman
                              if (teacherModel.chairman)
                                const SizedBox(height: 4),

                              //
                              if (teacherModel.chairman)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.greenAccent.shade100,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 1,
                                  ),
                                  child: Text(
                                    'Chairman',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ThemeData()
                                          .textTheme
                                          .titleLarge!
                                          .color,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
