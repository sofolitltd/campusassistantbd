import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '/models/profile_data.dart';

class AddRoutine extends StatefulWidget {
  const AddRoutine({super.key, required this.profileData});

  final ProfileData profileData;

  @override
  State<AddRoutine> createState() => _AddRoutineState();
}

class _AddRoutineState extends State<AddRoutine> {
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
        title: const Text('Add Routine'),
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
                                await uploadImageFile(widget.profileData);
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
  Future uploadImageFile(ProfileData profileData) async {
    String fileId = const Uuid().v4();
    var time = DateFormat('dd-MM-yyyy AT hh:mm a').format(DateTime.now());

    //
    final filePath =
        'Universities/${profileData.university}/${profileData.department}/routine';

    //
    final destination = '$filePath/$fileId.jpg';

    //todo: fix web view
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
        .doc(profileData.university)
        .collection('Departments')
        .doc(profileData.department)
        .collection('Routine')
        .doc(fileId)
        .set({
      'title': _titleController.text.trim(),
      'time': time,
      'imageUrl': downloadedUrl,
    });

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
