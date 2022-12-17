import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '/models/student_model.dart';
import '/utils/constants.dart';
import '/models/user_model.dart';
import '/widgets/open_app.dart';
import '../edit_student.dart';
import 'batch_student_card.dart';

class StudentCard extends StatelessWidget {
  const StudentCard(
      {Key? key, required this.studentModel, required this.userModel})
      : super(key: key);

  final StudentModel studentModel;
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    var shareToken = 'Name: ${studentModel.name}'
        '\nID: ${studentModel.id}'
        '\nBatch: ${userModel.batch}'
        '\n\nYour verification code is: ${studentModel.token}'
        '\n\nApp on play store- https://play.google.com/store/apps/details?id=com.sofolit.campusassistant';

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
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: GestureDetector(
                      onDoubleTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullImage(
                                    imageUrl: studentModel.imageUrl)));
                      },
                      child: CachedNetworkImage(
                        height: 88,
                        fit: BoxFit.cover,
                        imageUrl: studentModel.imageUrl,
                        fadeInDuration: const Duration(milliseconds: 500),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                const CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/pp_placeholder.png',
                              // fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                //info, call
                Expanded(
                  flex: 6,
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
                                        .labelMedium!
                                        .copyWith(),
                                  ),
                                  Text(
                                    studentModel.id,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontWeight: FontWeight.w600),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //id
                                     Text(
                                      'Blood ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(),
                                    ),
                                    Text(
                                      studentModel.blood,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(fontWeight: FontWeight.w600,color: Colors.red,),
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
                                const Text('Hall',
                                    style: TextStyle(fontSize: 12)),
                                Text(
                                  studentModel.hall,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                        ],
                      ),

                      //call
                      if (userModel.role[UserRole.cr.name] &&
                          studentModel.phone.isNotEmpty)
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
                )
              ],
            ),
          ),

          // admin
          if (userModel.role[UserRole.cr.name])
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
                            Clipboard.setData(ClipboardData(text: shareToken))
                                .then(
                              (value) {
                                Fluttertoast.showToast(
                                    msg: 'Copy to clipboard');
                              },
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
                  else
                    GestureDetector(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Generate Token'),
                            content: const Text(
                                'Sure to regenerate verification token?'),
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
                                    //
                                    await FirebaseFirestore.instance
                                        .collection('Universities')
                                        .doc(userModel.university)
                                        .collection('Departments')
                                        .doc(userModel.department)
                                        .collection('Students')
                                        .doc('Batches')
                                        .collection(userModel.batch)
                                        .doc(studentModel.id)
                                        .update({
                                      'token': createToken(
                                          batch: userModel.batch,
                                          id: studentModel.id),
                                    }).then((value) => Navigator.pop(context));
                                  },
                                  child: const Text('Generate')),

                              const SizedBox(width: 4),
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
                      //delete
                      PopupMenuItem(
                          value: 1,
                          onTap: () {
                            //
                            Future(() =>
                                //
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditStudent(
                                        userModel: userModel,
                                        selectedBatch: userModel.batch,
                                        studentModel: studentModel,
                                      ),
                                    )));
                          },
                          child: const Text('Edit')),

                      //delete
                      PopupMenuItem(
                          value: 2,
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('Universities')
                                .doc(userModel.university)
                                .collection('Departments')
                                .doc(userModel.department)
                                .collection('Students')
                                .doc('Batches')
                                .collection(userModel.batch)
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

//
class FullImage extends StatelessWidget {
  final String imageUrl;

  const FullImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.pop(context);
        },
        child: SafeArea(
          child: Center(
            child: InteractiveViewer(
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                imageUrl: imageUrl,
                fadeInDuration: const Duration(milliseconds: 500),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/pp_placeholder.png',
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
