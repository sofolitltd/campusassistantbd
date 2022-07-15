import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '/models/notice_model.dart';
import '/models/user_model.dart';

class UploadNoticeEdit extends StatefulWidget {
  final UserModel userModel;
  final NoticeModel noticeModel;
  final String noticeId;

  const UploadNoticeEdit({
    Key? key,
    required this.userModel,
    required this.noticeModel,
    required this.noticeId,
  }) : super(key: key);

  @override
  State<UploadNoticeEdit> createState() => _UploadNoticeState();
}

class _UploadNoticeState extends State<UploadNoticeEdit> {
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
            Row(
              children: [
                CircleAvatar(
                  minRadius: 24,
                  backgroundImage:
                      NetworkImage(widget.noticeModel.uploaderImage),
                ),

                const SizedBox(width: 8),

                //
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.noticeModel.uploaderName),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border.all(width: .5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text(
                        'Class Representative',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 8),

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

    NoticeModel noticeModel = NoticeModel(
      uploaderName: widget.noticeModel.uploaderName,
      uploaderImage: widget.noticeModel.uploaderImage,
      batch: widget.noticeModel.batch,
      message: _messageController.text.toString(),
      time: time,
      seen: widget.noticeModel.seen,
    );

    //
    FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.userModel.university)
        .collection('Departments')
        .doc(widget.userModel.department)
        .collection('Notifications')
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
