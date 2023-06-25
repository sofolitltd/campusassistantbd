import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '/models/profile_data.dart';
import '/models/student_model.dart';
import '/utils/create_verification_code.dart';
import '/widgets/open_app.dart';
import 'full_image.dart';
import 'student_edit.dart';

class AllBatchCardWidget extends StatelessWidget {
  const AllBatchCardWidget({
    Key? key,
    required this.profileData,
    required this.studentModel,
    required this.selectedBatch,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedBatch;
  final StudentModel studentModel;

  @override
  Widget build(BuildContext context) {
    String shareToken = 'Name: ${studentModel.name}'
        '\nID: ${studentModel.id}'
        '\nBatch: ${profileData.information.batch}'
        '\n\nYour verification code is: \n${studentModel.token}'
        '\n\nFor Android - https://play.google.com/store/apps/details?id=com.sofolit.campusassistant'
        '\n\nFor Apple device or Website - https://campusassistantbd.web.app';

    //
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // info
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
                      if ((selectedBatch == profileData.information.batch) ||
                          profileData.information.status!.moderator!) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullImage(
                                title: studentModel.name,
                                imageUrl: studentModel.imageUrl),
                          ),
                        );
                      }
                    },
                    child: studentModel.imageUrl == ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/pp_placeholder.png',
                              // fit: BoxFit.cover,
                              width: 88,
                              height: 88,
                            ),
                          )
                        : CachedNetworkImage(
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

                                //blood
                                if (studentModel.blood.isNotEmpty)
                                  const SizedBox(
                                    height: 24,
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
                        if (profileData.information.status!.moderator!)
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

          // code[moderator only]
          if ((profileData.information.batch! == selectedBatch &&
                  profileData.information.status!.cr!) ||
              profileData.information.status!.moderator!)
            Container(
              height: 36,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  const Text('Code: '),

                  const SizedBox(width: 8),

                  // copy token
                  (studentModel.token != 'USED')
                      ? GestureDetector(
                          onTap: () async {
                            //add verify code
                            await addVerificationCode(
                                studentModel,
                                profileData.university,
                                profileData.department,
                                selectedBatch);

                            // copy
                            Clipboard.setData(ClipboardData(text: shareToken))
                                .then((value) => Fluttertoast.showToast(
                                    msg: 'Copy to clipboard'));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 8,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.copy_outlined, size: 16),
                                const SizedBox(width: 4),
                                Text(studentModel.token),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade300,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline_outlined,
                                  size: 16),
                              const SizedBox(width: 4),
                              Text(studentModel.token),
                            ],
                          ),
                        ),

                  const SizedBox(width: 8),

                  //

                  if (studentModel.token != 'USED')
                    GestureDetector(
                      onTap: () async {
                        //add verify code
                        await addVerificationCode(
                          studentModel,
                          profileData.university,
                          profileData.department,
                          selectedBatch,
                        );

                        // share
                        Share.share(shareToken);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 8,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.share_outlined, size: 16),
                            SizedBox(width: 4),
                            Text('Share'),
                          ],
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Regenerate Code'),
                            content: const Text(
                                'Sure to Regenerate verification code?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel')),

                              //
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(40, 40)),
                                  onPressed: () async {
                                    String code = createToken();

                                    // check code already exist
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

                                    //add to /verifications
                                    await FirebaseFirestore.instance
                                        .collection('verifications')
                                        .doc(code)
                                        .set({
                                      'university': profileData.university,
                                      'department': profileData.department,
                                      'profession': 'student',
                                      'code': code,
                                      'name': studentModel.name,
                                      'information': {
                                        'batch': selectedBatch,
                                        'id': studentModel.id,
                                        'session': studentModel.session,
                                        'hall': studentModel.hall,
                                        'blood': studentModel.blood,
                                      }
                                    });

                                    // update code in student db
                                    await FirebaseFirestore.instance
                                        .collection('Universities')
                                        .doc(profileData.university)
                                        .collection('Departments')
                                        .doc(profileData.department)
                                        .collection('students')
                                        .doc('batches')
                                        .collection(selectedBatch)
                                        .doc(studentModel.id)
                                        .update({
                                      'token': code,
                                      'imageUrl': '',
                                    });

                                    //delete image
                                    if (studentModel.imageUrl != '') {
                                      await FirebaseStorage.instance
                                          .refFromURL(studentModel.imageUrl)
                                          .delete();
                                    }

                                    // add to trash
                                    String uid = '';
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .where('email',
                                            isEqualTo: studentModel.email)
                                        .get()
                                        .then((value) async {
                                      for (var element in value.docs) {
                                        if (element.exists) {
                                          uid = await element.get('uid');
                                          dev.log('uid exist: $uid');
                                        } else {
                                          dev.log('no email found');
                                        }
                                      }
                                    });

                                    // for admin to delete later
                                    await FirebaseFirestore.instance
                                        .collection('trash')
                                        .doc(studentModel.email)
                                        .set({
                                      'email': studentModel.email,
                                      'uid': uid,
                                    });

                                    // delete user
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(uid)
                                        .delete()
                                        .then((value) {
                                      // Navigator.pop(context);
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: const Text('Generate')),

                              const SizedBox(width: 4),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 8,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.touch_app_outlined, size: 16),
                            SizedBox(width: 4),
                            Text('Regenerate Code'),
                          ],
                        ),
                      ),
                    ),

                  const Spacer(),

                  //
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      //delete
                      PopupMenuItem(
                          value: 1,
                          onTap: () {
                            //
                            Future(
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditStudent(
                                    university: profileData.university,
                                    department: profileData.department,
                                    selectedBatch: selectedBatch,
                                    studentModel: studentModel,
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
                            // delete from verification
                            await FirebaseFirestore.instance
                                .collection('verifications')
                                .where('code', isEqualTo: studentModel.token)
                                .get()
                                .then((value) {
                              for (var element in value.docs) {
                                String id = element.id;
                                FirebaseFirestore.instance
                                    .collection('verifications')
                                    .doc(id)
                                    .delete();
                              }
                            });

                            // delete from student list
                            await FirebaseFirestore.instance
                                .collection('Universities')
                                .doc(profileData.university)
                                .collection('Departments')
                                .doc(profileData.department)
                                .collection('students')
                                .doc('batches')
                                .collection(selectedBatch)
                                .doc(studentModel.id)
                                .delete();
                          },
                          child: const Text('Delete')),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

//add  verification code
addVerificationCode(StudentModel studentModel, String university,
    String department, batch) async {
  // check code already exist
  await FirebaseFirestore.instance
      .collection('verifications')
      .doc(studentModel.token)
      .get()
      .then((element) {
    if (element.exists) {
      dev.log('Code exist,so copy if for: ${studentModel.id}');
    } else {
      dev.log('Code not exist, so add it for: ${studentModel.id}');
      FirebaseFirestore.instance
          .collection('verifications')
          .doc(studentModel.token)
          .set({
        'university': university,
        'department': department,
        'profession': 'student',
        'code': studentModel.token,
        'name': studentModel.name,
        'information': {
          'batch': batch,
          'id': studentModel.id,
          'session': studentModel.session,
          'hall': studentModel.hall,
          'blood': studentModel.blood,
        }
      });
    }
  });
}
