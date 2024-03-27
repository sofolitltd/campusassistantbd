import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../../../models/course_model_new.dart';
import '/utils/constants.dart';

class EditCourse extends StatefulWidget {
  const EditCourse({
    super.key,
    required this.university,
    required this.department,
    required this.selectedSemester,
    required this.courseId,
    required this.courseModel,
    required this.batches,
  });

  final String university;
  final String department;
  final String selectedSemester;
  final String courseId;
  final CourseModelNew courseModel;
  final List<String> batches;

  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _courseTitleController = TextEditingController();
  final TextEditingController _courseMarksController = TextEditingController();
  final TextEditingController _courseCreditsController =
      TextEditingController();

  String? _selectedCourseCategory;
  List<String>? _selectedBatches;
  bool _isLoading = false;

  File? _pickedMobileImage;
  Uint8List _webImage = Uint8List(8);

  @override
  void initState() {
    _courseCodeController.text = widget.courseModel.courseCode;
    _courseTitleController.text = widget.courseModel.courseTitle;
    _courseMarksController.text = widget.courseModel.courseMarks;
    _courseCreditsController.text = widget.courseModel.courseCredits;
    _selectedBatches = widget.courseModel.batches.cast<String>();
    _selectedCourseCategory = widget.courseModel.courseCategory;
    super.initState();
  }

  @override
  void dispose() {
    _courseCodeController.dispose();
    _courseTitleController.dispose();
    _courseMarksController.dispose();
    _courseCreditsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              var ref = FirebaseFirestore.instance
                  .collection('Universities')
                  .doc(widget.university)
                  .collection('Departments')
                  .doc(widget.department)
                  .collection('courses')
                  .doc(widget.courseId);

              //delete
              await ref.delete().then((value) {
                Navigator.pop(context);
              });
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),

      //
      body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .2
                : 16,
            vertical: 16,
          ),
          children: [
            // path section
            buildPathSection(widget.selectedSemester),

            const SizedBox(height: 16),

            //
            Form(
              key: _formState,
              child: Column(
                children: [
                  //todo: course [edit image]

                  // category & code
                  Row(
                    children: [
                      //Type
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _selectedCourseCategory,
                          hint: const Text('Course Category'),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 8),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedCourseCategory = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? "Choose Course Category" : null,
                          items: kCourseCategory.map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // code
                      Expanded(
                        child: TextFormField(
                          controller: _courseCodeController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Course Code',
                            hintText: 'Psy 101',
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Course Code' : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //title
                  TextFormField(
                    controller: _courseTitleController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Course Title',
                      hintText: 'General Psychology',
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter Course Title" : null,
                  ),

                  const SizedBox(height: 16),

                  //marks & credits
                  Row(
                    children: [
                      // marks
                      Expanded(
                        child: TextFormField(
                          controller: _courseMarksController,
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Marks',
                            hintText: '100',
                            counterText: '',
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter Marks" : null,
                        ),
                      ),

                      const SizedBox(width: 8),

                      // credits
                      Expanded(
                        child: TextFormField(
                          controller: _courseCreditsController,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Credits',
                            hintText: '4',
                            counterText: '',
                          ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter Credits" : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

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
                              alignment: widget.courseModel.image.isNotEmpty
                                  ? Alignment.centerLeft
                                  : Alignment.center,
                              child: widget.courseModel.image.isNotEmpty
                                  ? Row(
                                      children: [
                                        Image.network(widget.courseModel.image),
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
                                              image: FileImage(
                                                  _pickedMobileImage!),
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
                  const SizedBox(height: 16),

                  // batches
                  MultiSelectDialogField(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    selectedColor: Colors.blueAccent.shade100,
                    selectedItemsTextStyle:
                        const TextStyle(color: Colors.black),
                    title: const Text('Batches'),
                    buttonText: const Text('Batches'),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    initialValue: _selectedBatches!,
                    items: widget.batches
                        .map((e) => MultiSelectItem(e, e))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (List<String> values) {
                      setState(() {
                        _selectedBatches = values;
                      });
                    },
                    validator: (values) => (values == null || values.isEmpty)
                        ? "Select batch"
                        : null,
                  ),

                  const SizedBox(height: 16),

                  //
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formState.currentState!.validate()) {
                                setState(() => _isLoading = true);

                                //
                                String downloadedUrl = '';
                                downloadedUrl = widget.courseModel.image;

                                // upload new image
                                if (_pickedMobileImage != null) {
                                  downloadedUrl =
                                      await uploadImage(pathName: 'courses');

                                  // delete old image
                                  if (widget.courseModel.image != "") {
                                    await FirebaseStorage.instance
                                        .refFromURL(widget.courseModel.image)
                                        .delete()
                                        .whenComplete(() =>
                                            Fluttertoast.showToast(
                                                msg: 'Delete image ...'));
                                  }
                                }

                                //
                                CourseModelNew courseModel = CourseModelNew(
                                  courseYear: widget.selectedSemester,
                                  courseCategory: _selectedCourseCategory!,
                                  courseCode: _courseCodeController.text.trim(),
                                  courseTitle:
                                      _courseTitleController.text.trim(),
                                  courseCredits:
                                      _courseCreditsController.text.trim(),
                                  courseMarks:
                                      _courseMarksController.text.trim(),
                                  batches: _selectedBatches!,
                                  image: downloadedUrl,
                                );

                                // add course
                                await FirebaseFirestore.instance
                                    .collection('Universities')
                                    .doc(widget.university)
                                    .collection('Departments')
                                    .doc(widget.department)
                                    .collection('courses')
                                    .doc(widget.courseId)
                                    .update(courseModel.toJson());

                                Fluttertoast.showToast(
                                    msg: 'Update successfully');

                                //
                                setState(() => _isLoading = false);

                                //
                                if (!mounted) return;
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Update'.toUpperCase())),
                  ),
                ],
              ),
            )
          ]),
    );
  }

  // top path
  Wrap buildPathSection(String year) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        //
        const Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.account_tree_outlined,
            color: Colors.black87,
            size: 20,
          ),
        ),

        //
        Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(width: .5, color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(year)),
        const Icon(Icons.keyboard_arrow_right_rounded),
        const Text('Course Information'),
      ],
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
