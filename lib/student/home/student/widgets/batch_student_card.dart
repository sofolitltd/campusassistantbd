import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:share_plus/share_plus.dart';

import '/models/student_model.dart';
import '/models/user_model.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/open_app.dart';
import '../edit_student.dart';
import 'student_card.dart';

class BatchStudentCard extends StatelessWidget {
  const BatchStudentCard({
    Key? key,
    required this.studentModel,
    required this.selectedBatch,
    required this.userModel,
  }) : super(key: key);

  final StudentModel studentModel;
  final String selectedBatch;
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    var shareToken = 'Name: ${studentModel.name}'
        '\nID: ${studentModel.id}'
        '\nBatch: $selectedBatch'
        '\n\nYour verification code is: ${studentModel.token}'
        '\n\nApp on play store- https://play.google.com/store/apps/details?id=com.sofolit.campusassistant';

    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(userModel.university)
        .collection('Departments')
        .doc(userModel.department)
        .collection('Students')
        .doc('Batches')
        .collection(selectedBatch);

    //
    return Stack(
      alignment: Alignment.topRight,
      children: [
        //
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(0),
          child: Column(
            children: [
              //
              ListTile(
                contentPadding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 8,
                  bottom: 5,
                ),
                horizontalTitleGap: 12,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(FullImage(
                          title: studentModel.name,
                          imageUrl: studentModel.imageUrl));
                    },
                    child: CachedNetworkImage(
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      imageUrl: studentModel.imageUrl,
                      fadeInDuration: const Duration(milliseconds: 500),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                  'assets/images/pp_placeholder.png')),
                      errorWidget: (context, url, error) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              Image.asset('assets/images/pp_placeholder.png')),
                    ),
                  ),
                ),
                title: Text(
                  studentModel.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        // color: Colors.black,
                      ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // id, blood
                    Row(
                      children: [
                        //id
                        Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 1),
                          child: Text.rich(
                            TextSpan(
                              text: 'ID: ',
                              style: Theme.of(context).textTheme.subtitle2,
                              children: [
                                TextSpan(
                                  text: studentModel.id,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),

                        if (studentModel.blood.isNotEmpty)
                          const SizedBox(
                            height: 16,
                            child: VerticalDivider(
                              color: Colors.grey,
                            ),
                          ),

                        if (studentModel.blood.isNotEmpty)
                          //blood
                          Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 1),
                            child: Text.rich(
                              TextSpan(
                                text: 'Blood:  ',
                                style: Theme.of(context).textTheme.subtitle2,
                                children: [
                                  TextSpan(
                                    text: studentModel.blood,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                        ),
                                  )
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),

                    //
                    if (studentModel.hall != 'None')
                      Text(
                        studentModel.hall,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                  ],
                ),
                // call [admin]
                trailing: (userModel.role[UserRole.admin.name] &&
                        studentModel.phone.isNotEmpty)
                    ? IconButton(
                        onPressed: () {
                          OpenApp.withNumber(studentModel.phone);
                        },
                        icon: const Icon(
                          Icons.call_outlined,
                          color: Colors.green,
                        ),
                      )
                    : null,
              ),

              // admin
              if (userModel.role[UserRole.admin.name])
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
                              onTap: () {
                                //
                                Clipboard.setData(
                                        ClipboardData(text: shareToken))
                                    .then((value) {
                                  Fluttertoast.showToast(
                                      msg: 'Copy to clipboard');
                                });
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
                                color: Colors.green.shade200,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                      Icons.check_circle_outline_outlined,
                                      size: 16),
                                  const SizedBox(width: 4),
                                  Text(studentModel.token),
                                ],
                              ),
                            ),

                      const SizedBox(width: 8),

                      //
                      (studentModel.token != 'USED')
                          ? GestureDetector(
                              onTap: () {
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
                                child: Row(
                                  children: const [
                                    Icon(Icons.share_outlined, size: 16),
                                    SizedBox(width: 4),
                                    Text('Share'),
                                  ],
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Generate Token'),
                                    content: const Text(
                                        'Sure to re-generate verification token?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            //
                                            await ref
                                                .doc(studentModel.id)
                                                .update({
                                              'token': createToken(
                                                  batch: userModel.batch,
                                                  id: studentModel.id),
                                            }).then((value) =>
                                                    Navigator.pop(context));
                                          },
                                          child: const Text('Generate')),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).bottomAppBarColor,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.touch_app_outlined, size: 16),
                                    SizedBox(width: 4),
                                    Text('Generate Token'),
                                  ],
                                ),
                              ),
                            ),

                      const Spacer(),

                      //
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          //edit
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
                                      builder: (context) => EditStudent(
                                        userModel: userModel,
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
                                //
                                await ref.doc(studentModel.id).delete().then(
                                  (value) {
                                    Fluttertoast.showToast(
                                        msg: 'Successfully deleted');
                                  },
                                );
                              },
                              child: const Text('Delete')),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

//
String createToken({required String batch, required String id}) {
  var batchSub = batch.substring(batch.length - 2);
  var idSub = id.substring(id.length - 2);
  var num = Random().nextInt(9000) + 1000;
  return '$idSub$batchSub$num';
}
