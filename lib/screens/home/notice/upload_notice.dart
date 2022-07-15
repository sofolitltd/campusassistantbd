import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '/models/notice_model.dart';
import '/models/user_model.dart';

class UploadNotice extends StatefulWidget {
  final UserModel userModel;

  const UploadNotice({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<UploadNotice> createState() => _UploadNoticeState();
}

class _UploadNoticeState extends State<UploadNotice> {
  final TextEditingController _messageController = TextEditingController();
  bool isButtonActive = false;
  String counter = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

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
    // print(getDateTime());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userModel.batch),
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
                        postMessage();
                      }
                    : null,
                child: const Text('Post')),
          ),
        ],
      ),

      //
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ListView(
          children: [
            if (isLoading) const LinearProgressIndicator(),

            const SizedBox(height: 16),

            //admin profile
            Row(
              children: [
                CircleAvatar(
                  minRadius: 24,
                  backgroundImage: NetworkImage(widget.userModel.imageUrl),
                ),

                const SizedBox(width: 8),

                //
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userModel.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 2,
                        bottom: 3,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: .2),
                        borderRadius: BorderRadius.circular(2),
                        // color: Colors.orangeAccent.shade100,
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
  postMessage() {
    setState(() => isLoading = true);

    var time = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());

    NoticeModel noticeModel = NoticeModel(
      uploaderName: widget.userModel.name,
      uploaderImage: widget.userModel.imageUrl,
      batch: [widget.userModel.batch],
      message: _messageController.text.toString(),
      time: time,
      seen: [],
    );

    //
    FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.userModel.university)
        .collection('Departments')
        .doc(widget.userModel.department)
        .collection('Notifications')
        .add(noticeModel.toJson())
        .then((value) async {
      //
      await FirebaseFirestore.instance
          .collection("Users")
          .where('batch', isEqualTo: widget.userModel.batch)
          .get()
          .then((value) async {
        for (var element in value.docs) {
          var token = element.get('deviceToken');
          print(token);

          //
          await sendPushMessage(
            token: token,
            title: widget.userModel.name,
            body: _messageController.text,
          );
        }
      });

      //
      if (!mounted) return;
      Navigator.pop(context);

      //
      // Fluttertoast.showToast(msg: 'Post notice successfully');

      //
      setState(() => isLoading = false);
    });
  }

  //
  sendPushMessage({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      await http.post(
        // Uri.parse('https://fcm.googleapis.com/fcm/send'),
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/campusassistantbd/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              // 'key=AAAASdoJHIY:APA91bGsG2MPE-OASD4rq-YGpbdoVE_8HnVsC_hOPxStioi2WoPXVVOvC0vJqxRBP9UHFbSeIATgCSmAcGBZKQg_z2Gr2Ia4-HqKTHaYCavsD0Z0lAAUYPzMKUAc8v2nelf-HuU1tWqK',
              'Bearer AIzaSyC6GyOYVB353N2SjORdNaZvKThz8zapfyk',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'title': title, 'body': body},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification $e");
    }
  }
}
