import 'dart:io';

import 'package:campusassistant/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTransports extends StatefulWidget {
  final UserModel userModel;

  const AddTransports({Key? key, required this.userModel}) : super(key: key);

  @override
  State<AddTransports> createState() => _AddTransportsState();
}

class _AddTransportsState extends State<AddTransports> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  bool _isLoading = false;

  XFile? _pickedImage;

  UploadTask? task;
  bool isTaskActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transports'),
        centerTitle: true,
      ),

      //
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //title
                TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter title';
                    }
                    return null;
                  },
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
                              height: 400,
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

                //
                const SizedBox(height: 24),

                //
                if (_pickedImage != null)
                  ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_globalKey.currentState!.validate()) {
                                if (_pickedImage == null) {
                                  Fluttertoast.showToast(
                                      msg: 'No image selected');
                                }
                                setState(() => _isLoading = true);

                                // upload
                                await uploadImageFile(widget.userModel);
                              }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Upload'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // upload and download url
  Future uploadImageFile(UserModel userModel) async {
    String fileId = DateTime.now().millisecondsSinceEpoch.toString();
    var time = DateFormat('dd-MM-yyyy AT hh:mm a').format(DateTime.now());

    //
    final filePath = 'Universities/${userModel.university}/Transports';

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
    await FirebaseFirestore.instance
        .collection('Universities')
        .doc(userModel.university)
        .collection('Transports')
        .doc(fileId)
        .set(
      {
        'title': _titleController.text.trim(),
        'time': time,
        'imageUrl': downloadedUrl,
      },
    );

    //
    if (!mounted) return;
    Navigator.pop(context);

    setState(() => _isLoading = false);
  }

  //
  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //
    if (image == null) return;

    setState(() {
      _pickedImage = XFile(image.path);
    });
  }
}
