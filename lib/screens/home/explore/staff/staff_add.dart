import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '/models/profile_data.dart';
import '/models/staff_model.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({
    super.key,
    required this.university,
    required this.department,
    required this.profileData,
  });

  final String university;
  final String department;
  final ProfileData profileData;

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  int? _selectedSerial;
  bool _isLoading = false;
  File? _pickedMobileImage;
  Uint8List _webImage = Uint8List(8);

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.profileData.university)
        .collection('Departments')
        .doc(widget.profileData.department)
        .collection('Staff');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Staff'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ButtonTheme(
          alignedDropdown: true,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              //serial
              Row(
                children: [
                  Expanded(
                    flex: 1,
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

                  //post
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _postController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Assistant',
                        labelText: 'Post',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter post';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              //name
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'MD ...',
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person_pin_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter a name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              //phone
              TextFormField(
                controller: _phoneController,
                validator: (value) =>
                    (value!.isEmpty) ? 'Enter phone no' : null,
                decoration: const InputDecoration(
                  hintText: 'Phone',
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.call_outlined),
                ),
                keyboardType: TextInputType.phone,
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
              const SizedBox(height: 24),

              //
              ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_globalKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            // image upload and download
                            String downloadedUrl = '';

                            // upload new image
                            if (_pickedMobileImage != null) {
                              downloadedUrl = await uploadImage(
                                widget.profileData,
                                pathName: 'staff',
                              );
                            }

                            //
                            StaffModel staffModel = StaffModel(
                              name: _nameController.text.trim(),
                              post: _postController.text.trim(),
                              phone: _phoneController.text.trim(),
                              serial: _selectedSerial!,
                              imageUrl: downloadedUrl,
                            );

                            //
                            await ref
                                .doc()
                                .set(staffModel.toJson())
                                .then((value) {
                              setState(() => _isLoading = false);

                              Navigator.pop(context);
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text('Upload'.toUpperCase()))
            ],
          ),
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
