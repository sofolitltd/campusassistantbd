import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '/models/notice_model.dart';
import '/models/user_model.dart';

class NoticeAdd extends StatefulWidget {
  final UserModel userModel;

  const NoticeAdd({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<NoticeAdd> createState() => _NoticeAddState();
}

class _NoticeAddState extends State<NoticeAdd> {
  final TextEditingController _messageController = TextEditingController();
  bool isButtonActive = false;
  String counter = '';
  bool isLoading = false;
  XFile? _pickedImage;
  UploadTask? task;

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
                    ? () async {
                        setState(() => isButtonActive = true);
                        if (_pickedImage != null) {
                          await uploadImageFile(widget.userModel);
                        } else {
                          //
                          await postMessage('');
                        }
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

                    //
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type notice here!',
                hintStyle: TextStyle(fontSize: 20),
              ),
              onChanged: (value) => setState(() => counter = value),
              style: TextStyle(fontSize: counter.length < 100 ? 20 : 16),
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              minLines: 10,
              maxLines: 25,
            ),

            const SizedBox(height: 16),

            //
            _pickedImage == null
                ? OutlinedButton.icon(
                    icon: const Icon(Icons.image_outlined),
                    onPressed: _pickImage,
                    label: Text('Add image',
                        style: Theme.of(context).textTheme.titleMedium!
                        // .copyWith(color: Colors.red),
                        ),
                  )
                : Stack(
                    alignment: Alignment.topRight,
                    children: [
                      //
                      FittedBox(
                        child: Image.file(
                          File(_pickedImage!.path),
                          fit: BoxFit.cover,
                          // height: 300,
                        ),
                      ),

                      //
                      Material(
                        // color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _pickedImage = null;
                              });
                            },
                            icon: const Icon(Icons.clear)),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // upload and download url
  Future uploadImageFile(UserModel userModel) async {
    setState(() => isLoading = true);

    String fileId = const Uuid().v4();

    //
    final filePath =
        'Universities/${userModel.university}/${userModel.department}/Notice';

    //
    final destination = '$filePath/$fileId.jpg';

    task = FirebaseStorage.instance
        .ref(destination)
        .putFile(File(_pickedImage!.path));
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    var downloadedUrl = await snapshot.ref.getDownloadURL();
    // print('Download-Link: $downloadedUrl');

    // cloud fire store
    postMessage(downloadedUrl);
  }

  //
  postMessage(String downloadedUrl) {
    setState(() => isLoading = true);

    var time = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());

    NoticeModel noticeModel = NoticeModel(
      uploader: widget.userModel.uid,
      batch: [widget.userModel.batch],
      message: _messageController.text.toString(),
      imageUrl: [downloadedUrl],
      seen: [],
      time: time,
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
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/campusassistantbd/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ya29.AIzaSyC6GyOYVB353N2SjORdNaZvKThz8zapfyk',
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
      print("error push notification ${e}");
    }
  }

  //
  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //
    if (image == null) return;
    // ImageCropper imageCropper = ImageCropper();
    //
    // CroppedFile? croppedImage = await imageCropper.cropImage(
    //   sourcePath: image.path,
    //   cropStyle: CropStyle.rectangle,
    //   aspectRatioPresets: [
    //     CropAspectRatioPreset.original,
    //     CropAspectRatioPreset.square,
    //     CropAspectRatioPreset.ratio3x2,
    //     CropAspectRatioPreset.ratio4x3,
    //     CropAspectRatioPreset.ratio16x9,
    //   ],
    //   uiSettings: [
    //     AndroidUiSettings(
    //       toolbarTitle: 'image Customization',
    //       toolbarColor: ThemeData().cardColor,
    //       toolbarWidgetColor: Colors.deepOrange,
    //       initAspectRatio: CropAspectRatioPreset.square,
    //       lockAspectRatio: false,
    //     )
    //   ],
    // );
    // if (croppedImage == null) return;

    setState(() {
      // _pickedImage = XFile(croppedImage.path);
      _pickedImage = XFile(image.path);
    });
  }
}
