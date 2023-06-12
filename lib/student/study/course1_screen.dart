import 'package:campusassistant/student/study/upload/edit_year_semester.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';
import '/utils/constants.dart';
import '/widgets/headline.dart';
import 'course2_screen.dart';
import 'upload/add_year_semester.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  //
  static const routeName = '/course1';

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen>
    with AutomaticKeepAliveClientMixin {
  //
  @override
  bool get wantKeepAlive => true;

  UserModel? userModel;
  List yearList = [];
  String? _selectedSession;

  //
  getUser() async {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser)
        .get()
        .then((data) {
      setState(() {
        userModel = UserModel.fromJson(data);
        _selectedSession = userModel!.session;
      });
    });
  }

  //
  @override
  void initState() {
    getUser();
    super.initState();
  }

  //
  Widget buildYearButton() {
    return userModel != null
        ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Universities')
                .doc(userModel!.university)
                .collection('Departments')
                .doc(userModel!.department)
                .collection('Sessions')
                .orderBy('name', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Some thing went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                // loading state
                return const Text('');
              }

              var docs = snapshot.data!.docs;
              //batch
              return ButtonTheme(
                alignedDropdown: true,
                child: Card(
                  color: Colors.pink[100],
                  margin: const EdgeInsets.all(8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text(_selectedSession.toString()),
                      value: _selectedSession,
                      items: docs.map((item) {
                        // university name
                        return DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: item.get('name'),
                            child: Text(item.get('name')));
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedSession = value!;
                        });
                      },
                    ),
                  ),
                ),
              );
            },
          )
        : Container();
  }

  //session

  @override
  Widget build(BuildContext context) {
    //for automatic keep alive
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study'),
        actions: [
          buildYearButton(),
          const SizedBox(width: 8),
        ],
      ),

      // add year
      floatingActionButton:
          // only admin
          (userModel != null && userModel!.role[UserRole.admin.name])
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddYearOrSemester(userModel: userModel!)));
                  },
                  child: const Icon(Icons.add),
                )
              : null,

      body: userModel == null
          ? CircularProgressIndicator()
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 1000
                      ? MediaQuery.of(context).size.width * .2
                      : 12,
                  vertical: 12),
              children: [
                //
                const Headline(title: 'All Course'),

                //
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Universities')
                      .doc(userModel!.university)
                      .collection('Departments')
                      .doc(userModel!.department)
                      .collection('YearSemester')
                      .orderBy('name')
                      .where('sessionList', arrayContains: _selectedSession)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Some thing wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * .7,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    var data = snapshot.data!.docs;

                    if (data.isEmpty) {
                      return const Text(
                        'Sorry! No available information for your session now.\n'
                        'Please switch other session to view.',
                      );
                    }
                    //
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (context, index) => GestureDetector(
                        onLongPress: userModel!.role[UserRole.admin.name]
                            ? () {
                                //
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditYearOrSemester(
                                      userModel: userModel!,
                                      data: data[index],
                                    ),
                                  ),
                                );
                              }
                            : null,
                        onTap: () {
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseScreen2(
                                university: userModel!.university,
                                department: userModel!.department,
                                selectedYear: data[index].get('name'),
                                userModel: userModel!,
                                selectedSession: _selectedSession!,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.centerRight,
                          children: [
                            //
                            Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(right: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Container(
                                width: double.infinity,
                                height: 96,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //year title
                                    Text(
                                      data[index].get('name'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),

                                    // year sub title
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //
                                        Container(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          child: Row(
                                            // alignment: Alignment.centerRight,
                                            children: [
                                              const Text(
                                                'Courses:',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),

                                              const SizedBox(width: 8),
                                              //
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    border: Border.all(
                                                      color: Theme.of(context)
                                                          .dividerColor,
                                                    )),
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Text(
                                                  '${data[index].get('courses')}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        Container(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.greenAccent.shade100,
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          child: Row(
                                            // alignment: Alignment.centerRight,
                                            children: [
                                              const Text(
                                                'Marks:',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),

                                              const SizedBox(width: 8),
                                              //
                                              Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 50),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    border: Border.all(
                                                      color: Theme.of(context)
                                                          .dividerColor,
                                                    )),
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Text(
                                                  '${data[index].get('marks')}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    data[index].get('credits'),
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
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              // const Icon(Icons.arrow_forward_ios_outlined),
                            )
                          ],
                        ),
                      ),
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 15),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
