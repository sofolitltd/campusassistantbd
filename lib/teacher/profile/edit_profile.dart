import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '/models/profile_data.dart';
import '../../utils/constants.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.profileData}) : super(key: key);

  final ProfileData profileData;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  List hallList = [];
  String? _selectedHall;
  String? _selectedBloodGroup;
  bool _isLoading = false;
  XFile? _pickedImage;

  @override
  void initState() {
    getHallList();

    _nameController.text = widget.profileData.name;
    _mobileController.text = widget.profileData.mobile;
    _selectedHall = widget.profileData.information.hall;
    _selectedBloodGroup = widget.profileData.information.blood;

    super.initState();
  }

  // get hall
  getHallList() {
    FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.profileData.university)
        .collection('Departments')
        .doc(widget.profileData.department)
        .collection('Halls')
        .orderBy('name')
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() => hallList.add(doc.get('name')));
        }
      },
    );
  }

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
        ),

        //[todo: web only]
        // WebUiSettings(
        //   context: context,
        // ),
      ],
    );
    if (croppedImage == null) return;

    setState(() {
      _pickedImage = XFile(croppedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Profile'),
      ),
      body: Form(
        key: _globalKey,
        child: ButtonTheme(
          alignedDropdown: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .2
                    : 16,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //image pick
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        GestureDetector(
                          onTap: () => _pickImage(),
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: _pickedImage == null
                                ? CachedNetworkImage(
                                    imageUrl: widget.profileData.image,
                                    fadeInDuration:
                                        const Duration(milliseconds: 500),
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundImage: imageProvider,
                                      radius: 120,
                                    ),
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        const CircleAvatar(
                                            radius: 120,
                                            backgroundImage: AssetImage(
                                                'assets/images/pp_placeholder.png')),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                            radius: 120,
                                            backgroundImage: AssetImage(
                                                'assets/images/pp_placeholder.png')),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      File(_pickedImage!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
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

                  //phone
                  TextFormField(
                    controller: _mobileController,
                    // validator: (value) => (value!.isEmpty)?'Enter mobile no': null,
                    decoration: const InputDecoration(
                      hintText: 'Mobile no',
                      labelText: 'Mobile no',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.call_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  // hall
                  DropdownButtonFormField(
                    isExpanded: true,
                    value: _selectedHall,
                    decoration: const InputDecoration(
                      label: Text('Hall'),
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
                    items: hallList.map((val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          val,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  //blood
                  DropdownButtonFormField(
                    value: _selectedBloodGroup,
                    // isExpanded: true,
                    decoration: const InputDecoration(
                      hintText: 'Blood Group',
                      labelText: 'Blood Group',
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

                  const SizedBox(height: 24),

                  //
                  ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_globalKey.currentState!.validate()) {
                                // setState(() => _isLoading = true);
                                //
                                // var ref = FirebaseFirestore.instance
                                //     .collection('users')
                                //     .doc(widget.profileData.uid);
                                //
                                // // if image change
                                // if (_pickedImage != null) {
                                //   uploadImageFile();
                                // }
                                //
                                // // with out change image
                                // await ref.update(
                                //   {
                                //     'name': _nameController.text.trim(),
                                //     'image': widget.profileData.image,
                                //     'information': {
                                //       'mobile': _mobileController.text.trim(),
                                //       'hall': _selectedHall,
                                //       'blood': _selectedBloodGroup,
                                //     }
                                //   },
                                // );

                                // todo: update student info
                                // await FirebaseFirestore.instance
                                //     .collection('Universities')
                                //     .doc(widget.profileData.university)
                                //     .collection('Departments')
                                //     .doc(widget.profileData.department)
                                //     .collection('Students')
                                //     .doc('Batches')
                                //     .collection(
                                //         widget.profileData.information.batch!)
                                //     .doc(widget.profileData.uid)
                                //     .update({
                                //   'phone': _mobileController.text,
                                //   'hall': _selectedHall,
                                //   'blood': _selectedBloodGroup,
                                //   'imageUrl': widget.profileData.image,
                                // });

                                //
                                // if (!mounted) return;
                                // Navigator.pop(context);
                              }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Update'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // upload and download url
  Future uploadImageFile() async {
    final filePath =
        'Users/${widget.profileData.university}/${widget.profileData.department}';
    final destination = '$filePath/${widget.profileData.information.id}.jpg';

    var task = FirebaseStorage.instance
        .ref(destination)
        .putFile(File(_pickedImage!.path));
    setState(() {});

    if (task != null) return;

    final snapshot = await task.whenComplete(() {});
    var downloadedUrl = await snapshot.ref.getDownloadURL();
    // print('Download-Link: $downloadedUrl');

    // update user info
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profileData.uid)
        .update(
      {
        'name': _nameController.text,
        'phone': _mobileController.text,
        'hall': _selectedHall,
        'blood': _selectedBloodGroup,
        'imageUrl': downloadedUrl,
      },
    );

    // todo: update student info
    // await FirebaseFirestore.instance
    //     .collection('Universities')
    //     .doc(widget.profileData.university)
    //     .collection('Departments')
    //     .doc(widget.profileData.department)
    //     .collection('Students')
    //     .doc('Batches')
    //     .collection(widget.profileData.information.batch!)
    //     .doc(widget.profileData.information.id)
    //     .update(
    //   {
    //     // 'name': _nameController.text,
    //     'phone': _mobileController.text,
    //     'hall': _selectedHall,
    //     'blood': _selectedBloodGroup,
    //     'imageUrl': downloadedUrl,
    //   },
    // );
  }
}

class WebUiSettings {}
