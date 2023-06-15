import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '/models/content_model.dart';
import '/models/profile_data.dart';

///Study/2nd Year/Practical Course/Psy 207/Notes/Lessons/02/sxusycT5qFMLYx91ec1Z

class EditContent extends StatefulWidget {
  const EditContent({
    key,
    required this.selectedYear,
    required this.profileData,
    required this.contentModel,
    required this.batches,
  }) : super(key: key);

  final String selectedYear;
  final ProfileData profileData;
  final ContentModel contentModel;
  final List<String> batches;

  @override
  State<EditContent> createState() => _EditContentState();
}

class _EditContentState extends State<EditContent> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _contentTitleController = TextEditingController();
  final TextEditingController _contentSubtitleController =
      TextEditingController();

  String _selectedStatus = 'basic';
  List<String>? _selectedBatches;

  String? fileName;
  String? fileType;
  File? _selectedMobileFile;
  Uint8List _selectedWebFile = Uint8List(8);
  UploadTask? task;
  bool _isLoadingDelete = false;
  bool _isLoading = false;

  @override
  void initState() {
    fileName = 'Update file';
    _contentTitleController.text = widget.contentModel.contentTitle;
    _contentSubtitleController.text = widget.contentModel.contentSubtitle;
    _selectedBatches = widget.contentModel.batches;
    _selectedStatus = widget.contentModel.status;
    super.initState();
  }

  @override
  void dispose() {
    _contentTitleController.dispose();
    _contentSubtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Edit ${widget.contentModel.contentType}'),
        actions: [
          IconButton(
            onPressed: _isLoadingDelete
                ? null
                : () async {
                    setState(() => _isLoadingDelete = true);
                    // delete file
                    await FirebaseStorage.instance
                        .refFromURL(widget.contentModel.fileUrl)
                        .delete()
                        .then((value) {
                      //delete database
                      FirebaseFirestore.instance
                          .collection('Universities')
                          .doc(widget.profileData.university)
                          .collection('Departments')
                          .doc(widget.profileData.department)
                          .collection(
                              widget.contentModel.contentType.toLowerCase())
                          .doc(widget.contentModel.contentId)
                          .delete()
                          .then((value) {
                        setState(() => _isLoadingDelete = false);
                        Navigator.pop(context);
                      });
                    });
                  },
            icon: _isLoadingDelete
                ? const SizedBox(
                    height: 24, width: 24, child: CircularProgressIndicator())
                : const Icon(Icons.delete),
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
          //
          buildPathSection(
            year: widget.selectedYear,
            courseCode: widget.contentModel.courseCode,
            chapterNo: widget.contentModel.lessonNo.toString(),
            courseType: widget.contentModel.contentType,
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
                    )),
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
                    labelText: getContentSubtitle(
                        courseType:
                            widget.contentModel.contentType.toLowerCase()),
                    // widget.courseType == 'notes' ? 'Creator' : 'Year',
                    hintText: getContentSubtitle(
                        courseType:
                            widget.contentModel.contentType.toLowerCase()),
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
                          }),
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
                        },
                      ),
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
                onPressed: _isLoading
                    ? null
                    : () async {
                        //
                        if (fileName != 'Update file' &&
                            _formState.currentState!.validate()) {
                          //delete old file
                          await FirebaseStorage.instance
                              .refFromURL(widget.contentModel.fileUrl)
                              .delete();

                          // put new file
                          task = putContentOnStorage();
                          setState(() {});
                          if (task == null) return;
                          progressDialog(context, task!);

                          // download link
                          final snapshot = await task!.whenComplete(() {});
                          String downloadedUrl =
                              await snapshot.ref.getDownloadURL();
                          await updateFileToFireStore(
                            fileUrl: downloadedUrl,
                          );
                        } else {
                          setState(() => _isLoading = true);

                          await updateFileToFireStore(
                            fileUrl: widget.contentModel.fileUrl,
                          );
                          setState(() => _isLoading = false);
                        }
                      },
                label: _isLoading
                    ? const SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Update File')),
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
      // fileType = result.files.first.extension;
      // print(fileType);

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
        '${widget.contentModel.courseCode}_${_contentTitleController.text.replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), '_')}_${_contentSubtitleController.text.replaceAll(RegExp('[^A-Za-z0-9]'), '_')}_${DateTime.now().microsecond}.pdf';

    final ref = FirebaseStorage.instance
        .ref('Universities')
        .child(widget.profileData.university)
        .child(widget.profileData.department)
        .child(widget.contentModel.contentType.toLowerCase())
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
  updateFileToFireStore({required String fileUrl}) async {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.profileData.university)
        .collection('Departments')
        .doc(widget.profileData.department)
        .collection(widget.contentModel.contentType.toLowerCase())
        .doc(widget.contentModel.contentId);

    //
    await ref.update(
      {
        'contentTitle': _contentTitleController.text.trim(),
        'contentSubtitle': _contentSubtitleController.text.trim(),
        'batches': _selectedBatches,
        'fileUrl': fileUrl,
        'status': _selectedStatus,
      },
    ).then((value) {
      Navigator.pop(context);
    });
  }
}

// show dialog
progressDialog(BuildContext context, UploadTask task) {
  FocusManager.instance.primaryFocus!.unfocus();

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.all(12),
      title: Stack(
        alignment: Alignment.centerRight,
        children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Uploading File',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),

          //
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: const Icon(
                Icons.close_outlined,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      titlePadding: const EdgeInsets.all(12),
      content: StreamBuilder<TaskSnapshot>(
          stream: task.snapshotEvents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final snap = snapshot.data!;
              final progress = snap.bytesTransferred / snap.totalBytes;
              final percentage = (progress * 100).toStringAsFixed(0);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: LinearProgressIndicator(
                      minHeight: 16,
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueAccent.shade200),
                      backgroundColor:
                          Colors.lightBlueAccent.shade100.withOpacity(.2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('$percentage %'),
                  const SizedBox(height: 8),
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: LinearProgressIndicator(
                      minHeight: 16,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueAccent.shade200),
                      backgroundColor:
                          Colors.lightBlueAccent.shade100.withOpacity(.2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(' '),
                  const SizedBox(height: 8),
                ],
              );
            }
          }),
    ),
  );
}

// content subtitle
getContentSubtitle({required String courseType}) {
  switch (courseType) {
    case 'notes':
      {
        return 'Creator';
      }
    case 'books':
      {
        return 'Author';
      }
  }
  return 'Year';
}

//
Widget buildPathSection(
    {required String year,
    required String courseType,
    required String courseCode,
    String? chapterNo}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
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
      Flexible(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // year
            Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(width: .5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(year)),

            //courseCode
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.keyboard_arrow_right_rounded),
                Text(courseCode),
              ],
            ),

            //chapterNo
            if (courseType == 'Notes')
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.keyboard_arrow_right_rounded),
                  Text('Chapter ${chapterNo!}'),
                ],
              ),
            //courseType
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.keyboard_arrow_right_rounded),
                Text(courseType),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
