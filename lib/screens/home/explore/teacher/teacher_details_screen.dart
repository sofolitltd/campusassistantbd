import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '/models/profile_data.dart';
import '/models/teacher_model.dart';
import '/utils/create_verification_code.dart';
import '/widgets/open_app.dart';

class TeacherDetailsScreen extends StatelessWidget {
  const TeacherDetailsScreen({
    super.key,
    required this.teacherModel,
    required this.university,
    required this.department,
    required this.profileData,
  });

  final TeacherModel teacherModel;
  final String university;
  final String department;
  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          // backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                    onPressed: () async {
                      String shareableText =
                          '${teacherModel.name}\n${teacherModel.post}\n${teacherModel.phd}\n\nMobile: ${teacherModel.mobile}\nEmail: ${teacherModel.email}\n\nPublications: ${teacherModel.publications}\n\nInterest: ${teacherModel.interests}\n\n${teacherModel.imageUrl}';

                      //

                      await Share.share(shareableText,
                          subject: 'Profile of ${teacherModel.name}');
                    },
                    icon: const Icon(Icons.share)),
              )
            ],
          ),

          //
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .25
                    : 0,
              ),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.hardEdge,
                children: [
                  //
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        //
                        Container(
                          margin: const EdgeInsets.only(top: 88),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300, blurRadius: 8)
                            ],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 80),

                              //
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    teacherModel.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    teacherModel.post,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),

                                  //
                                  const SizedBox(height: 4),

                                  //
                                  if (teacherModel.phd.isNotEmpty)
                                    Text(
                                      teacherModel.phd,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),

                                  const SizedBox(height: 8),

                                  //
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: Row(
                                      children: [
                                        //publication
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: const StadiumBorder(),
                                            ),
                                            onPressed: () async {
                                              final url =
                                                  teacherModel.publications;
                                              //
                                              if (teacherModel
                                                  .publications.isNotEmpty) {
                                                OpenApp.withUrl(url);
                                              } else {
                                                Fluttertoast.cancel();
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'No publications found');
                                              }
                                            },
                                            // color: Colors.black,
                                            // padding: const EdgeInsets.symmetric(
                                            //     vertical: 13),
                                            // shape: RoundedRectangleBorder(
                                            //     borderRadius:
                                            //         BorderRadius.circular(8)),
                                            child: const Padding(
                                              padding: EdgeInsets.all(13),
                                              child: Text(
                                                "Publications",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  // color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        // mail
                                        MaterialButton(
                                          minWidth: 32,
                                          onPressed: () {
                                            OpenApp.withEmail(
                                                teacherModel.email);
                                          },
                                          elevation: 4,
                                          color: Colors.red,
                                          padding: const EdgeInsets.all(
                                              kIsWeb ? 16 : 10),
                                          shape: const CircleBorder(),
                                          child: const Icon(
                                            Icons.mail,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        //call
                                        MaterialButton(
                                          minWidth: 32,
                                          onPressed: () {
                                            OpenApp.withNumber(
                                                teacherModel.mobile);
                                          },
                                          elevation: 4,
                                          color: Colors.green,
                                          padding: const EdgeInsets.all(
                                              kIsWeb ? 16 : 10),
                                          shape: const CircleBorder(),
                                          child: const Icon(
                                            Icons.call,
                                            size: 24,
                                            color: Colors.white,
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

                        //
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300, blurRadius: 8)
                            ],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (teacherModel.mobile.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //mobile
                                    const Text(
                                      "Mobile: ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(height: 4),
                                    SelectableText(
                                      teacherModel.mobile,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(height: 12),

                                    //email
                                    if (teacherModel.email.isNotEmpty)
                                      const Text(
                                        "Email: ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    const SizedBox(height: 4),
                                    SelectableText(
                                      teacherModel.email,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),

                              if (teacherModel.interests.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(height: 24),

                                    //Interest
                                    const Text(
                                      "Field of Interest: ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                    ),

                                    //
                                    const SizedBox(height: 4),
                                    Text(teacherModel.interests,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300)),
                                  ],
                                ),

                              //
                              const SizedBox(height: 24),

                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('verification')
                                    .where('profession', isEqualTo: 'teacher')
                                    .where('information.email',
                                        isEqualTo: teacherModel.email)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(child: Text(''));
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(child: SizedBox());
                                  }

                                  var data = snapshot.data!.docs;
                                  String code = createToken();
                                  if (snapshot.data!.size == 0) {
                                    //generate code
                                    return SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          //check code already exist or not

                                          await FirebaseFirestore.instance
                                              .collection('verifications')
                                              .doc(code)
                                              .get()
                                              .then((element) {
                                            if (element.exists) {
                                              String newCode = createToken();
                                              code = newCode;
                                              dev.log('New Code: $code');
                                            } else {
                                              dev.log('Old Code: $code');
                                            }
                                          });

                                          //add to ->verifications
                                          await FirebaseFirestore.instance
                                              .collection('verification')
                                              .doc(code)
                                              .set({
                                            'university': university,
                                            'department': department,
                                            'profession': 'teacher',
                                            'code': code,
                                            'name': teacherModel.name,
                                            'information': {
                                              'email': teacherModel.email,
                                              'mobile': teacherModel.mobile,
                                            }
                                          });

                                          //
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade400,
                                        ),
                                        icon: const Icon(
                                          Icons.share,
                                          size: 16,
                                        ),
                                        label: Text(
                                          'Generate Verification Code'
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  //share code
                                  return SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                        onPressed: () {
                                          String shareableTest = 'Hello Sir,'
                                              '\n\n Registration code: $code';

                                          Share.share(shareableTest,
                                              subject:
                                                  "Campus Assistant code for registration");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        icon: const Icon(
                                          Icons.share,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        label: Text(
                                          'Share Verification Code'
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.2,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //img
                  Positioned(
                    top: 0,
                    child: Hero(
                      tag: teacherModel.name,
                      child: SizedBox(
                        width: 160,
                        height: 180,
                        child: CachedNetworkImage(
                          imageUrl: teacherModel.imageUrl,
                          fadeInDuration: const Duration(milliseconds: 500),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16), //
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300, blurRadius: 8)
                              ],
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fill),
                            ),
                          ),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/pp_placeholder.png'),
                              ),
                            ),
                            child: const Center(
                                child: CupertinoActivityIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/pp_placeholder.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
