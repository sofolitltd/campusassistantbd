import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/cr_model.dart';
import '../../../../utils/constants.dart';
import '/models/profile_data.dart';

class EditCR extends StatefulWidget {
  const EditCR({
    super.key,
    required this.docID,
    required this.profileData,
    required this.crModel,
    required this.batchList,
  });

  final String docID;
  final ProfileData profileData;
  final CrModel crModel;
  final List<String> batchList;

  @override
  State<EditCR> createState() => _EditCRState();
}

class _EditCRState extends State<EditCR> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fbController = TextEditingController();

  String? _selectedYear;
  String? _selectedBatch;
  bool _isLoading = false;

  File? _pickedMobileImage;
  Uint8List _webImage = Uint8List(8);

  @override
  void initState() {
    _nameController.text = widget.crModel.name;
    _emailController.text = widget.crModel.email;
    _phoneController.text = widget.crModel.phone;
    _fbController.text = widget.crModel.fb;
    _selectedBatch = widget.crModel.batch;
    _selectedYear = widget.crModel.year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.profileData.university)
        .collection('Departments')
        .doc(widget.profileData.department)
        .collection('Cr');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit CR'),
        actions: [
          IconButton(
              onPressed: () async {
                await ref.doc(widget.docID).delete().then((value) async {
                  if (widget.crModel.imageUrl.isNotEmpty) {
                    FirebaseStorage.instance
                        .refFromURL(widget.crModel.imageUrl);
                  }
                  Navigator.pop(context);
                });
              },
              icon: const Icon(Icons.delete)),
        ],
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

              //email
              TextFormField(
                controller: _emailController,
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return 'Enter email';
                //   }
                //   //todo: email verify
                //   return null;
                // },
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              //phone
              TextFormField(
                controller: _phoneController,
                // validator: (value) => (value!.isEmpty)?'Enter phone no': null,
                decoration: const InputDecoration(
                  hintText: 'Phone',
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.call_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              //fb
              TextFormField(
                controller: _fbController,
                // validator: (value) => value!.isEmpty ?'Enter fb link': null,
                decoration: const InputDecoration(
                  hintText: 'Fb Link',
                  labelText: 'Fb Link',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.facebook_outlined),
                ),
                minLines: 1,
                maxLines: 3,
                keyboardType: TextInputType.url,
              ),

              const SizedBox(height: 16),

              // batch
              DropdownButtonFormField(
                isExpanded: true,
                value: _selectedBatch,
                hint: const Text('Select Batch'),
                // isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                  prefixIcon: Icon(Icons.stacked_bar_chart_outlined),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _selectedBatch = value!;
                  });
                },
                validator: (value) => value == null ? "Select batch" : null,
                items: widget.batchList.reversed.map((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // hall
              DropdownButtonFormField(
                isExpanded: true,
                value: _selectedYear,
                hint: const Text('Select Year'),
                // isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _selectedYear = value;
                  });
                },
                validator: (value) => value == null ? "Select year" : null,
                items: kYearList.map((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
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
                          alignment: widget.crModel.imageUrl.isNotEmpty
                              ? Alignment.centerLeft
                              : Alignment.center,
                          child: widget.crModel.imageUrl.isNotEmpty
                              ? Row(
                                  children: [
                                    Image.network(widget.crModel.imageUrl),
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

              const SizedBox(height: 24),

              //
              ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_globalKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            //
                            String downloadedUrl = '';
                            downloadedUrl = widget.crModel.imageUrl;

                            // upload new image
                            if (_pickedMobileImage != null) {
                              downloadedUrl = await uploadImage(
                                  widget.profileData,
                                  pathName: 'cr');

                              // delete old image
                              if (widget.crModel.imageUrl != "") {
                                await FirebaseStorage.instance
                                    .refFromURL(widget.crModel.imageUrl)
                                    .delete()
                                    .whenComplete(() => Fluttertoast.showToast(
                                        msg: 'Delete image ...'));
                              }
                            }

                            CrModel crModel = CrModel(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.isEmpty
                                  ? ''
                                  : _phoneController.text.trim(),
                              fb: _fbController.text.isEmpty
                                  ? ''
                                  : _fbController.text.trim(),
                              batch: _selectedBatch!,
                              year: _selectedYear!,
                              imageUrl: downloadedUrl,
                            );

                            //
                            await ref
                                .doc(widget.docID)
                                .update(crModel.toJson())
                                .then((value) {
                              setState(() => _isLoading = false);

                              Navigator.pop(context);
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Update'))
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
