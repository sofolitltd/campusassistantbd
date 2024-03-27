import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'universities.dart';

class EditUniversity extends StatefulWidget {
  const EditUniversity({super.key, required this.university});

  final UniversityModel university;

  @override
  State<EditUniversity> createState() => _EditUniversityState();
}

class _EditUniversityState extends State<EditUniversity> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _facultiesController = TextEditingController();
  final TextEditingController _departmentsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  bool _isLoading = false;

  File? _pickedMobileImage;
  Uint8List _webImage = Uint8List(8);
  bool isUpload = false;
  var passText = '';

  @override
  void initState() {
    _nameController.text = widget.university.name;
    _facultiesController.text = widget.university.faculties;
    _departmentsController.text = widget.university.departments;
    _areaController.text = widget.university.area;
    _websiteController.text = widget.university.website;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(_nameController.text.trim());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit University'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                // delete doc
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delete',
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              //
                              TextField(
                                onChanged: (text) {
                                  passText = text;
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Password',
                                    border: OutlineInputBorder()),
                              ),

                              const SizedBox(height: 16),

                              ElevatedButton(
                                  onPressed: () async {
                                    if (passText == '1122') {
                                      //
                                      await ref.delete().then((value) async {
                                        //check and del storage
                                        //todo: fix later [need api access]
                                        await FirebaseFirestore.instance
                                            .collection('trashUn')
                                            .doc()
                                            .set({
                                          "name": widget.university.name,
                                          "path":
                                              'Universities/${widget.university.name}',
                                        }).then((value) {
                                          Fluttertoast.showToast(
                                              msg: 'Delete successfully');

                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      });
                                    } else if (passText.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'Please provide password!');
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Wrong password!');
                                    }
                                  },
                                  child: const Text('Confirm Delete'))
                            ],
                          ),
                        ));
              },
              icon: const Icon(Icons.delete)),
          const SizedBox(width: 8),
        ],
      ),

      //
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .2
                : 16,
            vertical: 16,
          ),
          children: [
            //
            TextFormField(
              enabled: false,
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: 'University Name',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter University Name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _facultiesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Faculties',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter Faculties';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _departmentsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Departments',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter Departments';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Area',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter Area';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            TextFormField(
              controller: _websiteController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                hintText: 'Website',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter Website';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            //image
            _pickedMobileImage == null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await pickImage(context);
                      },
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                        ),
                        padding: const EdgeInsets.all(8),
                        alignment: widget.university.images[0].isNotEmpty
                            ? Alignment.centerLeft
                            : Alignment.center,
                        child: widget.university.images[0].isNotEmpty
                            ? Row(
                                children: [
                                  Image.network(widget.university.images[0]),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 24),
                                    child: Text(
                                      'Tap to change image',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              )
                            : const Text(
                                'No image selected',
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      await pickImage(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            //
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.blueGrey.shade100),
                                image: kIsWeb
                                    ? DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: MemoryImage(_webImage),
                                      )
                                    : DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: FileImage(_pickedMobileImage!),
                                      ),
                              ),
                            ),

                            //
                            const Padding(
                              padding: EdgeInsets.only(left: 24),
                              child: Text(
                                'One image selected ',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

            const SizedBox(height: 24),

            //
            ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        //
                        if (_globalKey.currentState!.validate()) {
                          setState(() => _isLoading = true);

                          //
                          String downloadedUrl = '';
                          downloadedUrl = widget.university.images[0];

                          // with out image
                          if (_pickedMobileImage != null) {
                            downloadedUrl =
                                await uploadImage(_nameController.text.trim());
                          }

                          //
                          UniversityModel universityModel = UniversityModel(
                            name: _nameController.text.trim(),
                            faculties: _facultiesController.text.trim(),
                            departments: _departmentsController.text.trim(),
                            website: _websiteController.text.trim(),
                            area: _areaController.text.trim(),
                            images: [downloadedUrl],
                          );

                          // add university
                          await FirebaseFirestore.instance
                              .collection('Universities')
                              .doc(_nameController.text.trim())
                              .update(universityModel.toJson())
                              .then((value) {
                            setState(() => _isLoading = false);
                            Navigator.pop(context);
                          });
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text('Update now'.toUpperCase()))
          ],
        ),
      ),
    );
  }

//add image
  pickImage(context) async {
    // Pick an image
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    //
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: image!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 40,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        //android
        AndroidUiSettings(
          toolbarTitle: 'image Customization',
          toolbarColor: ThemeData().cardColor,
          toolbarWidgetColor: Colors.deepOrange,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),

        //web
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 350,
            height: 350,
          ),
          viewPort:
              const CroppieViewPort(width: 350, height: 350, type: 'square'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );

    if (!kIsWeb) {
      if (croppedImage != null) {
        var selectedMobileImage = File(croppedImage.path);
        setState(() {
          _pickedMobileImage = selectedMobileImage;
        });
      }
    } else if (kIsWeb) {
      if (croppedImage != null) {
        var selectedWebImage = await croppedImage.readAsBytes();
        setState(() {
          _webImage = selectedWebImage;
          _pickedMobileImage = File('');
        });
      }
    }
  }

  //upload image
  Future<String> uploadImage(String university) async {
    String downloadedUrl = '';

    //
    Reference ref = FirebaseStorage.instance
        .ref('Universities/$university/images')
        .child('$university.jpg');

    //
    if (kIsWeb) {
      await ref.putData(_webImage);
    } else {
      await ref.putFile(_pickedMobileImage!);
    }
    downloadedUrl = await ref.getDownloadURL();
    return downloadedUrl;
  }
}
