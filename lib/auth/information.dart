import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/constants.dart';
import 'signup/signup.dart';

class Information extends StatefulWidget {
  static const routeName = '/information';

  const Information({
    Key? key,
    required this.uid,
    required this.university,
    required this.department,
    required this.batch,
    required this.name,
    required this.id,
    required this.session,
    required this.mobile,
  }) : super(key: key);

  final String uid;
  final String university;
  final String department;
  final String batch;
  final String name;
  final String id;
  final String session;
  final String mobile;

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String? _selectedHall;
  String? _selectedBloodGroup;
  XFile? _pickedImage;
  UploadTask? task;
  final List<String> _hallList = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _mobileController.text = widget.mobile;
    getHallList();
  }

  getHallList() {
    FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
        .collection('Halls')
        .orderBy('id')
        .get()
        .then(
      (value) {
        for (var element in value.docs) {
          var hall = element.get('name');
          setState(() {
            _hallList.add(hall);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User information'),
        centerTitle: true,
      ),

      //
      body: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                //image pick
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      //
                      GestureDetector(
                        onTap: () => _pickImage(),
                        child: Container(
                          height: 160,
                          width: 160,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: _pickedImage == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                      'assets/images/pp_placeholder.png',
                                      fit: BoxFit.cover))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.file(
                                    File(_pickedImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),

                      //
                      Positioned(
                        bottom: 0,
                        right: 16,
                        child: MaterialButton(
                          onPressed: () => _pickImage(),
                          shape: const CircleBorder(),
                          color: Colors.grey.shade300,
                          padding: const EdgeInsets.all(12),
                          minWidth: 24,
                          child: const Icon(Icons.camera),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                //name
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person_pin_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                //mobile
                TextFormField(
                  controller: _mobileController,
                  validator: (value) {
                    if (value == null) {
                      return 'Enter Mobile Number';
                    } else if (value.length < 11 || value.length > 11) {
                      return 'Mobile Number at least 11 digits';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Mobile Number',
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_android_outlined),
                  ),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),

                // hall
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: _selectedHall,
                    hint: const Text('Choose Hall'),
                    // isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                      prefixIcon: Icon(Icons.home_work_outlined),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedHall = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Select your hall" : null,
                    items: _hallList.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                //blood
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                    value: _selectedBloodGroup,
                    hint: const Text('Blood Group'),
                    // isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                      prefixIcon: Icon(Icons.bloodtype_outlined),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedBloodGroup = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Select your blood group" : null,
                    items: kBloodGroup.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // button
                ElevatedButton(
                  onPressed: () {
                    if (_globalKey.currentState!.validate()) {
                      if (_pickedImage == null) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('No image selected!'),
                                  content: const Text(
                                      'For identification we need your picture. Try to use formal picture.'),
                                  actionsPadding: const EdgeInsets.only(
                                    right: 12,
                                    bottom: 12,
                                  ),
                                  actions: [
                                    //cancel
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel')),

                                    //pic image
                                    ElevatedButton(
                                        onPressed: () async {
                                          await _pickImage();
                                          if (!mounted) return;
                                          Navigator.pop(context);
                                        },
                                        child:
                                            const Text('Choose your picture')),
                                  ],
                                ));
                      } else {
                        //
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Signup(
                              uid: widget.uid,
                              university: widget.university,
                              department: widget.department,
                              batch: widget.batch,
                              session: widget.session,
                              id: widget.id,
                              name: _nameController.text,
                              phone: _mobileController.text,
                              selectedHall: _selectedHall!,
                              bloodGroup: _selectedBloodGroup!,
                              image: _pickedImage,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Next'.toUpperCase()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // image picker
  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;
    ImageCropper imageCropper = ImageCropper();

    CroppedFile? croppedImage = await imageCropper.cropImage(
      sourcePath: image.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'image Customization',
          toolbarColor: ThemeData().cardColor,
          toolbarWidgetColor: Colors.deepOrange,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        )
      ],
    );
    if (croppedImage == null) return;

    setState(() {
      _pickedImage = XFile(croppedImage.path);
    });
  }
}
