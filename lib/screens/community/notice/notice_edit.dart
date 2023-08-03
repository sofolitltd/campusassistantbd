import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '/models/notice_model.dart';
import '/models/profile_data.dart';

class NoticeEdit extends StatefulWidget {
  final ProfileData profileData;
  final NoticeModel noticeModel;
  final String noticeId;
  final DocumentSnapshot uploader;

  const NoticeEdit({
    Key? key,
    required this.profileData,
    required this.noticeModel,
    required this.noticeId,
    required this.uploader,
  }) : super(key: key);

  @override
  State<NoticeEdit> createState() => _UploadNoticeState();
}

class _UploadNoticeState extends State<NoticeEdit> {
  bool isButtonActive = false;
  final TextEditingController _messageController = TextEditingController();
  String counter = '';

  @override
  void initState() {
    super.initState();

    if (widget.noticeModel.message.isNotEmpty) {
      _messageController.text = widget.noticeModel.message;
    }

    //
    _messageController.addListener(() {
      final isButtonActive = _messageController.text.isNotEmpty;
      setState(() {
        this.isButtonActive = isButtonActive;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Notice"),
        elevation: 0,
        titleSpacing: 0,
        actions: [
          // post button
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
            child: ElevatedButton(
                onPressed: isButtonActive
                    ? () {
                        setState(() => isButtonActive = true);

                        //
                        editMessage();
                      }
                    : null,
                child: const Text('Post')),
          ),
        ],
      ),

      //
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //admin profile
            ListTile(
              contentPadding: EdgeInsets.zero,
              // image
              leading: CachedNetworkImage(
                imageUrl: widget.uploader.get('image'),
                fadeInDuration: const Duration(milliseconds: 500),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  // radius: 120,
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const CircleAvatar(
                        // radius: 120,
                        backgroundImage:
                            AssetImage('assets/images/pp_placeholder.png')),
                errorWidget: (context, url, error) => const CircleAvatar(
                    // radius: 120,
                    backgroundImage:
                        AssetImage('assets/images/pp_placeholder.png')),
              ),

              title: Text(
                widget.uploader.get('name'),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              //time

              subtitle: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: .5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      'Moderator',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // message
            TextFormField(
              controller: _messageController,
              // autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type notice here!',
                hintStyle: TextStyle(fontSize: 20),
                // counterText: counter.length.toString(),
              ),
              onChanged: (value) => setState(() => counter = value),
              style: TextStyle(fontSize: counter.length < 100 ? 20 : 16),
              textCapitalization: TextCapitalization.sentences,
              minLines: 10,
              maxLines: 25,
            ),
          ],
        ),
      ),
    );
  }

  //
  editMessage() {
    var time = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
    // var time = DateTime.now().toString();

    NoticeModel noticeModel = NoticeModel(
      uploader: widget.noticeModel.uploader,
      imageUrl: widget.noticeModel.imageUrl,
      batch: widget.noticeModel.batch,
      message: _messageController.text.toString(),
      time: time,
      seen: widget.noticeModel.seen,
    );

    //
    FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.profileData.university)
        .collection('Departments')
        .doc(widget.profileData.department)
        .collection('notices')
        .doc(widget.noticeId)
        .update(noticeModel.toJson())
        .then((value) async {
      //
      // await FirebaseFirestore.instance
      //     .collection("Users")
      //     .where('batch', isEqualTo: widget.userModel.batch)
      //     .get()
      //     .then((value) async {
      //   for (var element in value.docs) {
      //     var token = element.get('deviceToken');
      //     print(token);
      //
      //     //
      //     await sendPushMessage(
      //       token: token,
      //       title: widget.userModel.name,
      //       body: _messageController.text,
      //     );
      //   }
      // });

      //
      if (!mounted) return;
      Navigator.pop(context);

      //
      Fluttertoast.showToast(msg: 'Edit notice successfully');
    });
  }
}
