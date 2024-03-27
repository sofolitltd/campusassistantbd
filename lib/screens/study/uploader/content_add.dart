import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../widgets/content_subtitle_widget.dart';
import '../widgets/progress_dialog.dart';
import '/models/content_model.dart';
import '/models/course_model_new.dart';
import '/models/profile_data.dart';
import '/screens/study/widgets/path_section_widget.dart';

class AddContent extends StatefulWidget {
  const AddContent({
    super.key,
    required this.university,
    required this.department,
    required this.profileData,
    required this.selectedSemester,
    required this.courseType,
    required this.courseModel,
    required this.batches,
    this.chapterNo,
  });

  final String university;
  final String department;
  final ProfileData profileData;
  final String selectedSemester;
  final String courseType;
  final CourseModelNew courseModel;
  final int? chapterNo;
  final List<String> batches;

  @override
  State<AddContent> createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _contentTitleController = TextEditingController();
  final TextEditingController _contentSubtitleController =
      TextEditingController();

  String _selectedStatus = 'basic';
  List<String>? _selectedBatches;

  String? fileName;
  File? _selectedMobileFile;
  Uint8List _selectedWebFile = Uint8List(8);
  UploadTask? task;

  @override
  void initState() {
    _selectedBatches = [widget.profileData.information.batch!];
    super.initState();
  }

  @override
  void dispose() {
    _contentTitleController.dispose();
    _contentSubtitleController.dispose();
    // _selectedSessionList!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Upload ${widget.courseType}'),
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
          // file path
          pathSectionWidget(
            year: widget.selectedSemester,
            courseCode: widget.courseModel.courseCode,
            chapterNo: widget.chapterNo.toString(),
            courseType: widget.courseType,
          ),

          const SizedBox(height: 16),

          // choose file
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4)),
            child: ListTile(
              onTap: pickFile,
              contentPadding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
              horizontalTitleGap: 0,
              shape: const RoundedRectangleBorder(),
              leading: const Icon(Icons.file_copy_outlined),
              title: (fileName == null || _selectedWebFile.isEmpty)
                  ? const Text('No File Selected',
                      style: TextStyle(color: Colors.red))
                  : SelectableText(
                      fileName!,
                      style: const TextStyle(),
                    ),
              trailing: InkWell(
                onTap: pickFile,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4)),
                  child: const Icon(
                    Icons.attach_file_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          //
          Form(
            key: _formState,
            child: Column(
              children: [
                // title
                TextFormField(
                  controller: _contentTitleController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'File Title',
                    hintText: 'Introduction',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter Chapter Title" : null,
                ),

                const SizedBox(height: 16),

                // subtitle
                TextFormField(
                  controller: _contentSubtitleController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText:
                        contentSubtitleWidget(courseType: widget.courseType),
                    // widget.courseType == 'Notes' ? 'Creator' : 'Year',
                    hintText:
                        contentSubtitleWidget(courseType: widget.courseType),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter Chapter Title" : null,
                ),

                const SizedBox(height: 16),

                // batches
                MultiSelectDialogField(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  selectedColor: Colors.blueAccent.shade100,
                  selectedItemsTextStyle: const TextStyle(color: Colors.black),
                  title: const Text('Batches'),
                  buttonText: const Text('Batches'),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  initialValue: _selectedBatches!,
                  items:
                      widget.batches.map((e) => MultiSelectItem(e, e)).toList(),
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

                const SizedBox(height: 8),

                //
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Basic'),
                        value: 'basic',
                        groupValue: _selectedStatus,
                        onChanged: (String? val) {
                          setState(() {
                            _selectedStatus = val!;
                          });
                        },
                      ),
                    ),

                    // pro
                    Expanded(
                      child: RadioListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Pro'),
                          value: 'pro',
                          groupValue: _selectedStatus,
                          onChanged: (String? val) {
                            setState(() {
                              _selectedStatus = val!;
                            });
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          //
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload_outlined),
                onPressed: () async {
                  if (_selectedMobileFile == null) {
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(msg: 'No File Selected !');
                  } else if (_formState.currentState!.validate()) {
                    // put file
                    task = putContentOnStorage();
                    setState(() {});
                    if (task == null) return;
                    progressDialog(context, task!);

                    // download link
                    final snapshot = await task!.whenComplete(() {});
                    String downloadedUrl = await snapshot.ref.getDownloadURL();

                    // fire store
                    await uploadFileToFireStore(fileUrl: downloadedUrl);
                  }
                },
                label: const Text('Upload File')),
          ),
        ],
      ),
    );
  }

  // pick file
  pickFile() async {
    //open file manager
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    //
    if (result != null) {
      fileName = result.files.first.name;

      if (!kIsWeb) {
        final path = result.files.first.path!;
        var selectedMobileFile = File(path);
        setState(() {
          _selectedMobileFile = selectedMobileFile;
        });
      } else if (kIsWeb) {
        var selectedWebFile = result.files.first.bytes;
        setState(() {
          _selectedWebFile = selectedWebFile!;
          _selectedMobileFile = File('');
        });
      }
    } else {
      // User canceled the picker
    }
  }

  // upload file to storage
  UploadTask? putContentOnStorage() {
    var fileName =
        '${widget.courseModel.courseCode}_${_contentTitleController.text.replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), ' ')}_${_contentSubtitleController.text.replaceAll(RegExp('[^A-Za-z0-9]'), ' ')}_${DateTime.now().microsecond}.pdf';

    ///Universities/University of Chittagong/Departments/Department of Psychology
    final ref = FirebaseStorage.instance
        .ref('Universities')
        .child(widget.university)
        .child(widget.department)
        .child(widget.courseType.toLowerCase())
        .child(fileName);

    try {
      if (kIsWeb) {
        return ref.putData(
          _selectedWebFile,
          SettableMetadata(
            contentType: 'application/pdf',
          ),
        );
      } else {
        return ref.putFile(_selectedMobileFile!);
      }
    } on FirebaseException catch (e) {
      log('Content upload error: ${e.message!}');
      return null;
    }
  }

  // upload file to fire store
  uploadFileToFireStore({required String fileUrl}) async {
    //time
    String uploadDate = DateFormat('dd MMM, yyyy').format(DateTime.now());

    // uid
    String contentId = DateTime.now().millisecondsSinceEpoch.toString();

    // model
    ContentModel courseContentModel = ContentModel(
      contentId: contentId,
      courseCode: widget.courseModel.courseCode,
      contentType: widget.courseType.toLowerCase(),
      lessonNo:
          widget.courseType.toLowerCase() == 'notes' ? widget.chapterNo! : 1,
      status: _selectedStatus,
      batches: _selectedBatches!,
      contentTitle: _contentTitleController.text.trim(),
      contentSubtitle: _contentSubtitleController.text.trim(),
      contentSubtitleType: contentSubtitleWidget(courseType: widget.courseType),
      uploadDate: uploadDate,
      fileUrl: fileUrl,
      imageUrl: '',
      uploader:
          '${widget.profileData.name.trim().split(' ').last}(${widget.profileData.information.session})',
    );
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
        .collection('Departments')
        .doc(widget.department)
        .collection(widget.courseType.toLowerCase())
        .doc(contentId);
    log(ref.toString());

    // add to /notes
    await ref.set(courseContentModel.toJson()).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
