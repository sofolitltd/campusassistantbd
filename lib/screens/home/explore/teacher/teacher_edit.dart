import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '/models/profile_data.dart';
import '/models/teacher_model.dart';

class TeacherEdit extends StatefulWidget {
  const TeacherEdit({
    super.key,
    required this.university,
    required this.department,
    required this.profileData,
    required this.teacherModel,
    required this.present,
  });

  final String university;
  final String department;
  final ProfileData profileData;
  final TeacherModel teacherModel;
  final bool present;

  @override
  State<TeacherEdit> createState() => _TeacherEditState();
}

class _TeacherEditState extends State<TeacherEdit> {
  int? _selectedSerial;
  String? _selectedPost;
  bool? _isPresent;
  bool? _isChairman;
  bool _isLoading = false;

  File? _pickedMobileImage;
  Uint8List _webImage = Uint8List(8);

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phdController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _publicationsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    _selectedSerial = widget.teacherModel.serial;
    _selectedPost = widget.teacherModel.post;
    _nameController.text = widget.teacherModel.name;
    _mobileController.text = widget.teacherModel.mobile;
    _emailController.text = widget.teacherModel.email;
    _phdController.text = widget.teacherModel.phd;
    _interestController.text = widget.teacherModel.interests;
    _publicationsController.text = widget.teacherModel.publications;

    _isPresent = widget.teacherModel.present;
    _isChairman = widget.teacherModel.chairman;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
        .collection('Departments')
        .doc(widget.department)
        .collection('Teachers')
        .doc(widget.teacherModel.id);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Edit Teacher'),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () async {
                  // delete doc
                  await ref.delete().then((value) {
                    Fluttertoast.showToast(msg: 'Delete successfully');
                    Navigator.pop(context);
                  });
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
              Row(
                children: [
                  // serial no
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        label: Text('Serial No'),
                        hintText: 'Serial No',
                      ),
                      value: _selectedSerial,
                      isExpanded: true,
                      items: List.generate(40, (index) => 1 + index++)
                          .map((serial) {
                        return DropdownMenuItem<int>(
                          alignment: Alignment.center,
                          value: serial,
                          child: Text(serial.toString()),
                        );
                      }).toList(),
                      onChanged: (int? newSerial) {
                        setState(() => _selectedSerial = newSerial);
                      },
                      validator: (val) => val == null ? 'Select serial' : null,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // post
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Select Post'),
                          hintText: 'Select Post',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12)),
                      value: _selectedPost,
                      isExpanded: true,
                      items: postList
                          .map(
                            (post) => DropdownMenuItem<String>(
                              value: post,
                              child: Text(post),
                            ),
                          )
                          .toList(),
                      onChanged: (newPost) {
                        setState(() => _selectedPost = newPost);
                      },
                      validator: (val) => val == null ? 'Select post' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              //name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  label: Text('Name'),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),

              const SizedBox(height: 10),

              //mobile
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  hintText: 'Mobile',
                  label: Text('Mobile'),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                textInputAction: TextInputAction.next,
                // maxLength: 11,
                keyboardType: TextInputType.phone,
                // validator: (val) => val!.isEmpty
                //     ? 'Enter mobile no'
                //     : val.length < 11
                //         ? 'Mobile no must be 11 digits'
                //         : null,
              ),

              const SizedBox(height: 10),

              //email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  label: Text('Email'),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                // validator: (val) => val!.isEmpty ? 'Enter email' : null,
              ),

              const SizedBox(height: 10),

              // phd
              TextFormField(
                controller: _phdController,
                decoration: const InputDecoration(
                  hintText: 'Phd',
                  label: Text('Phd'),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 10),

              //interest
              TextFormField(
                controller: _interestController,
                decoration: const InputDecoration(
                  hintText: 'Interest',
                  label: Text('Interest'),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
              ),

              const SizedBox(height: 10),

              //publications
              TextFormField(
                controller: _publicationsController,
                decoration: const InputDecoration(
                  hintText: 'Publications',
                  label: Text('Publications'),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
              ),

              const SizedBox(height: 10),

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
                          alignment: widget.teacherModel.imageUrl.isNotEmpty
                              ? Alignment.centerLeft
                              : Alignment.center,
                          child: widget.teacherModel.imageUrl.isNotEmpty
                              ? Row(
                                  children: [
                                    Image.network(widget.teacherModel.imageUrl),
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
                                  border: Border.all(
                                      color: Colors.blueGrey.shade100),
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

              const SizedBox(height: 10),

              // present/absent & chairman
              Row(
                children: [
                  // p/a
                  Expanded(
                    child: Row(
                      children: [
                        const Text('Present: '),
                        Switch(
                          value: _isPresent!,
                          onChanged: (newValue) {
                            setState(() {
                              _isPresent = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  //chairman
                  Expanded(
                    child: Row(
                      children: [
                        const Text('Chairman: '),
                        Switch(
                          value: _isChairman!,
                          onChanged: (newValue) {
                            setState(() {
                              _isChairman = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              //
              ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_globalKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            //
                            String downloadedUrl = '';
                            downloadedUrl = widget.teacherModel.imageUrl;

                            // upload new image
                            if (_pickedMobileImage != null) {
                              downloadedUrl =
                                  await uploadImage(pathName: 'teacher');

                              // delete old image
                              if (widget.teacherModel.imageUrl != "") {
                                await FirebaseStorage.instance
                                    .refFromURL(widget.teacherModel.imageUrl)
                                    .delete()
                                    .whenComplete(() => Fluttertoast.showToast(
                                        msg: 'Delete image ...'));
                              }
                            }
                            //
                            TeacherModel teacher = TeacherModel(
                              id: widget.teacherModel.id,
                              serial: _selectedSerial!,
                              present: _isPresent!,
                              chairman: _isChairman!,
                              name: _nameController.text.trim(),
                              post: _selectedPost!,
                              mobile: _mobileController.text.trim(),
                              email: _emailController.text.trim(),
                              phd: _phdController.text.trim().isEmpty
                                  ? ''
                                  : _phdController.text.trim(),
                              interests: _interestController.text.trim().isEmpty
                                  ? ''
                                  : _interestController.text.trim(),
                              publications:
                                  _publicationsController.text.trim().isEmpty
                                      ? ''
                                      : _publicationsController.text.trim(),
                              imageUrl: downloadedUrl,
                              token: widget.teacherModel.token,
                            );

                            //
                            await ref.update(teacher.toJson()).then((value) {
                              //
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Successfully added')));

                              //
                              setState(() => _isLoading = false);
                              //
                              Navigator.pop(context);
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Update now')),
            ],
          ),
        ));
  }

  //
  List<String> postList = [
    'Professor',
    'Associate Professor',
    'Assistant Professor',
    'Lecturer',
  ];

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
          initAspectRatio: CropAspectRatioPreset.original,
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
  Future<String> uploadImage({required String pathName}) async {
    String downloadedUrl = '';

    String imageUid = DateTime.now().microsecondsSinceEpoch.toString();
    //
    Reference ref = FirebaseStorage.instance
        .ref('Universities/${widget.university}/${widget.department}/$pathName')
        .child('$imageUid.jpg');

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
