import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '/models/profile_data.dart';
import '/utils/constants.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.profileData});
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
  File? _pickedMobileImage;
  Uint8List _webImage = Uint8List(8);

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
                  Row(
                    children: [
                      //
                      _pickedMobileImage == null
                          ? Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        NetworkImage(widget.profileData.image),
                                  )),
                            )
                          : Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.blueGrey.shade100),
                                image: kIsWeb
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: MemoryImage(_webImage),
                                      )
                                    : DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(_pickedMobileImage!),
                                      ),
                              ),
                            ),

                      const SizedBox(width: 16),

                      //
                      Expanded(
                        child: SizedBox(
                          height: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '* Try to use formal photo.'
                                '\n* Female can use photo with Hijab & Nikab.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(height: 1.2),
                              ),

                              //
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _pickedMobileImage == null
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                                onPressed: () async {
                                  await pickImage(context);
                                },
                                child: Text(
                                  _pickedMobileImage == null
                                      ? 'Change your Photo'.toUpperCase()
                                      : 'New Photo Selected'.toUpperCase(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 24),

                  //name
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      labelText: 'Name',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      border: OutlineInputBorder(),
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
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _mobileController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter mobile no';
                            }
                            if (value.length != 11) {
                              return 'Mobile no must be 11 digits';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Mobile No',
                            labelText: 'Mobile No',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),

                      const SizedBox(width: 16),

                      //blood
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField(
                          value: _selectedBloodGroup,
                          // isExpanded: true,
                          decoration: const InputDecoration(
                            hintText: 'Blood Group',
                            labelText: 'Blood Group',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 4),
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
                    ],
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
                          EdgeInsets.symmetric(vertical: 13, horizontal: 4),
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

                  const SizedBox(height: 24),

                  //
                  ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_globalKey.currentState!.validate()) {
                                setState(() => _isLoading = true);

                                // if (_nameController.text.trim() ==
                                //         widget.profileData.name ||
                                //     _mobileController.text.trim() ==
                                //         widget.profileData.mobile ||
                                //     _selectedHall ==
                                //         widget.profileData.information.hall ||
                                //     _selectedBloodGroup ==
                                //         widget.profileData.information.blood ||
                                //     _pickedMobileImage == null) {
                                //   Navigator.pop(context);
                                // } else {

                                String imageUrl = widget.profileData.image;

                                // if image change
                                if (_pickedMobileImage != null) {
                                  imageUrl = await uploadAndGetImageUrl();
                                }

                                // with out change image
                                await updateUserInformation(image: imageUrl);

                                // update 0n student dataBase
                                await updateStudentInformation(image: imageUrl);

                                setState(() => _isLoading = false);
                                //
                                if (!mounted) return;
                                Navigator.pop(context);
                              }
                              // }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text('Update'.toUpperCase()))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // upload and download url
  uploadAndGetImageUrl() async {
    Reference ref = FirebaseStorage.instance
        .ref('Users')
        .child(widget.profileData.university)
        .child(widget.profileData.department)
        .child('${widget.profileData.information.id!}.jpg');

    String downloadedUrl = '';
    //
    if (kIsWeb) {
      await ref.putData(_webImage);
      downloadedUrl = await ref.getDownloadURL();
    } else {
      await ref.putFile(_pickedMobileImage!);
      downloadedUrl = await ref.getDownloadURL();
    }
    return downloadedUrl;
  }

  // update user info
  updateUserInformation({required String image}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profileData.uid)
        .update(
      {
        'name': _nameController.text.trim(),
        'image': image,
        'mobile': _mobileController.text.trim(),
        'information': {
          'batch': widget.profileData.information.batch,
          'id': widget.profileData.information.id,
          'session': widget.profileData.information.session,
          'hall': _selectedHall,
          'blood': _selectedBloodGroup,
          'status': {
            'admin': widget.profileData.information.status!.admin!,
            'moderator': widget.profileData.information.status!.moderator!,
            'cr': widget.profileData.information.status!.cr!,
            'subscriber': widget.profileData.information.status!.subscriber!,
          },
        },
      },
    );
  }

  // update student info
  updateStudentInformation({required String image}) async {
    await FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.profileData.university)
        .collection('Departments')
        .doc(widget.profileData.department)
        .collection('students')
        .doc('batches')
        .collection(widget.profileData.information.batch!)
        .doc(widget.profileData.information.id)
        .update({
      'phone': _mobileController.text.trim(),
      'hall': _selectedHall,
      'blood': _selectedBloodGroup,
      'imageUrl': image,
    });
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
}
