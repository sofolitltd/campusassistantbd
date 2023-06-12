import 'package:campusassistant/models/semester_model.dart';
import 'package:campusassistant/teacher/study/upload/semester_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../models/profile_data.dart';
import '../../widgets/headline.dart';
import '2courses.dart';
import 'upload/semester_add.dart';

class Study extends StatefulWidget {
  static const routeName = '/study';

  const Study({Key? key, required this.profileData}) : super(key: key);
  final ProfileData profileData;

  @override
  State<Study> createState() => _StudyState();
}

class _StudyState extends State<Study> with AutomaticKeepAliveClientMixin {
  //
  @override
  bool get wantKeepAlive => true;

  String? batch;
  List<String> batches = [];
  String? _selectedBatch;

  @override
  void initState() {
    getBatches(widget.profileData);
    super.initState();
  }

  //
  getBatches(ProfileData profileData) async {
    //
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(profileData.university)
        .collection('Departments')
        .doc(profileData.department)
        .collection('batches')
        .where('study', isEqualTo: true)
        .orderBy('name', descending: true);

    //
    await ref.get().then((snap) {
      for (var data in snap.docs) {
        var name = data.get('name');
        batches.add(name);
        if (profileData.information.batch == '') {
          _selectedBatch = batches.first;
        } else {
          _selectedBatch = profileData.information.batch;
        }
      }
    });
    setState(() {});
    // log(batchList.toString());
  }

  @override
  Widget build(BuildContext context) {
    //for automatic keep alive
    super.build(context);

    return Scaffold(
      //
      appBar: AppBar(
        title: const Text('Study'),
        actions: [
          (batches == [] || _selectedBatch == null)
              ? const SizedBox()
              : ButtonTheme(
                  alignedDropdown: true,
                  child: Card(
                    color: Colors.pink[100],
                    margin: const EdgeInsets.all(8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(_selectedBatch.toString()),
                        value: _selectedBatch,
                        items: batches.map((item) {
                          // university name
                          return DropdownMenuItem<String>(
                              alignment: Alignment.center,
                              value: item,
                              child: Text(item));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedBatch = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),

          //
          SizedBox(
            width: MediaQuery.of(context).size.width * .01,
          )
        ],
      ),

      // add semester
      floatingActionButton:
          (widget.profileData.information.status!.moderator! == true &&
                  batches != [])
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSemester(
                          profileData: widget.profileData,
                          batches: batches,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,

      //body
      body: (batches == [] || _selectedBatch == null)
          ? Container()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // archive
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 800
                          ? MediaQuery.of(context).size.width * .2
                          : 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        ArchiveCategoryCard(
                          title: 'Library',
                          subtitle: 'Book collection',
                          profileData: widget.profileData,
                        ),
                        const SizedBox(width: 16),
                        ArchiveCategoryCard(
                          title: 'Research',
                          subtitle: 'Research, Thesis paper',
                          profileData: widget.profileData,
                        ),
                      ],
                    ),
                  ),

                  // courses
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width > 1000
                              ? MediaQuery.of(context).size.width * .2
                              : 12,
                          vertical: 12),
                      children: [
                        //
                        const Headline(title: 'All Courses'),

                        //
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Universities')
                              .doc(widget.profileData.university)
                              .collection('Departments')
                              .doc(widget.profileData.department)
                              .collection('semesters')
                              .orderBy('title')
                              .where('batches', arrayContains: _selectedBatch)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Some thing wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * .7,
                                child: Center(
                                  child: SpinKitFoldingCube(
                                    size: 64,
                                    color: Colors.purple.shade100,
                                  ),
                                ),
                              );
                            }

                            var data = snapshot.data!.docs;

                            if (data.isEmpty) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Study Materials not yet Uploaded!',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              );
                            }

                            //
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: data.length,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemBuilder: (context, index) {
                                SemesterModel semester =
                                    SemesterModel.fromJson(data[index]);

                                //
                                return GestureDetector(
                                  onTap: () {
                                    //  semester
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Courses(
                                          profileData: widget.profileData,
                                          semester: semester.title,
                                          batches: batches,
                                          selectedBatch: _selectedBatch!,
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    if (widget.profileData.information.status!
                                            .moderator! ==
                                        true) {
                                      // edit semester
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditSemester(
                                            profileData: widget.profileData,
                                            batches: batches,
                                            semester: semester,
                                            semesterId: data[index].id,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.centerRight,
                                    children: [
                                      //
                                      Card(
                                        elevation: 2,
                                        margin:
                                            const EdgeInsets.only(right: 16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Container(
                                          width: double.infinity,
                                          height: 96,
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //year title
                                              Text(
                                                semester.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),

                                              // year sub title
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.blue.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32),
                                                    ),
                                                    child: Row(
                                                      // alignment: Alignment.centerRight,
                                                      children: [
                                                        const Text(
                                                          'Courses:',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),

                                                        const SizedBox(
                                                            width: 8),
                                                        //
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                  border: Border
                                                                      .all(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                  )),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          child: Text(
                                                            semester.courses,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  const SizedBox(width: 8),

                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .greenAccent.shade100,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32),
                                                    ),
                                                    child: Row(
                                                      // alignment: Alignment.centerRight,
                                                      children: [
                                                        const Text(
                                                          'Marks:',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),

                                                        const SizedBox(
                                                            width: 8),
                                                        //
                                                        Container(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  minWidth: 50),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              32),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .cardColor,
                                                                  border: Border
                                                                      .all(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .dividerColor,
                                                                  )),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          child: Text(
                                                            semester.marks,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      //
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.orangeAccent.shade100,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                spreadRadius: 4,
                                                offset: const Offset(1, 3)),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              semester.credits,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                            ),
                                            Text(
                                              'credits',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!
                                                  .copyWith(
                                                      color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        // const Icon(Icons.arrow_forward_ios_outlined),
                                      )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 15),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

//
class ArchiveCategoryCard extends StatelessWidget {
  const ArchiveCategoryCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.profileData,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Get.toNamed('/$title'.toLowerCase(), arguments: {
            'profileData': profileData,
          });
        },
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title
                Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                ),

                const SizedBox(height: 4),
                //sub
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
