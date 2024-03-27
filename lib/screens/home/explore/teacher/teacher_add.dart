import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '/models/profile_data.dart';
import '/models/teacher_model.dart';

class TeacherAdd extends StatefulWidget {
  const TeacherAdd(
      {super.key, required this.profileData, required this.present});

  final ProfileData profileData;
  final bool present;

  @override
  State<TeacherAdd> createState() => _TeacherAddState();
}

class _TeacherAddState extends State<TeacherAdd> {
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

  @override
  void initState() {
    _isPresent = widget.present;
    _isChairman = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add Teacher'),
          elevation: 0,
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
                          alignment: Alignment.center,
                          child: const Text(
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

                            String id = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            var token = Random().nextInt(9000) + 1000;

                            // image upload and download
                            String downloadedUrl = '';

                            // upload new image
                            if (_pickedMobileImage != null) {
                              downloadedUrl = await uploadImage(
                                  widget.profileData,
                                  pathName: 'teacher');
                            }

                            //
                            TeacherModel teacher = TeacherModel(
                              id: id,
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
                              token: token.toString(),
                            );

                            //
                            var ref = FirebaseFirestore.instance
                                .collection('Universities')
                                .doc(widget.profileData.university)
                                .collection('Departments')
                                .doc(widget.profileData.department)
                                .collection('Teachers')
                                .doc(id);

                            //
                            await ref.set(teacher.toJson()).then((value) {
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
                      : const Text('Add Now')),
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
  Future<String> uploadImage(ProfileData profileData,
      {required String pathName}) async {
    String downloadedUrl = '';

    String imageUid = DateTime.now().microsecondsSinceEpoch.toString();
    //
    Reference ref = FirebaseStorage.instance
        .ref(
            'Universities/${profileData.university}/${profileData.department}/$pathName')
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
