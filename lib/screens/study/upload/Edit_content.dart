import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '/models/content_model.dart';
import '/models/user_model.dart';
import '../../../utils/constants.dart';

///Study/2nd Year/Practical Course/Psy 207/Notes/Lessons/02/sxusycT5qFMLYx91ec1Z
class EditContent extends StatefulWidget {
  const EditContent({
    key,
    required this.userModel,
    required this.courseContentModel,
    this.chapterNo,
  }) : super(key: key);

  final UserModel userModel;
  final ContentModel courseContentModel;
  final int? chapterNo;

  @override
  State<EditContent> createState() => _EditContentState();
}

class _EditContentState extends State<EditContent> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _contentTitleController = TextEditingController();
  final TextEditingController _contentSubtitleController =
      TextEditingController();

  String _selectedStatus = 'Basic';
  List<String>? _selectedSessionList;

  String? fileName;
  String? fileType;
  File? selectedFile;
  UploadTask? task;

  @override
  void initState() {
    fileName = 'Update file';
    _contentTitleController.text = widget.courseContentModel.contentTitle;
    _contentSubtitleController.text = widget.courseContentModel.contentSubtitle;
    _selectedSessionList = widget.courseContentModel.sessionList;
    _selectedStatus = widget.courseContentModel.status;
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
        title: Text('Edit ${widget.courseContentModel.contentType}'),
      ),

      //
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //
          buildPathSection(
            year: '',
            courseCode: widget.courseContentModel.courseCode,
            chapterNo: widget.chapterNo.toString(),
            courseType: widget.courseContentModel.contentType,
          ),

          const SizedBox(height: 16),

          // choose file
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4)),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
              horizontalTitleGap: 0,
              shape: const RoundedRectangleBorder(),
              leading: const Icon(Icons.file_copy_outlined),
              title: fileName == null
                  ? const Text('No File Selected',
                      style: TextStyle(color: Colors.red))
                  : SelectableText(
                      fileName!,
                      style: const TextStyle(),
                    ),
              trailing: InkWell(
                onTap: () {
                  pickFile();
                },
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
                        courseType: widget.courseContentModel.contentType),
                    // widget.courseType == 'Notes' ? 'Creator' : 'Year',
                    hintText: getContentSubtitle(
                        courseType: widget.courseContentModel.contentType),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter Chapter Title" : null,
                ),

                const SizedBox(height: 16),

                // session list
                MultiSelectDialogField(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  selectedColor: Colors.blueAccent.shade100,
                  selectedItemsTextStyle: const TextStyle(color: Colors.black),
                  title: const Text('Session List'),
                  buttonText: const Text('Session List'),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  initialValue: _selectedSessionList,
                  items:
                      kSessionList.map((e) => MultiSelectItem(e, e)).toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (List<String> values) {
                    setState(() {
                      _selectedSessionList = values;
                    });
                  },
                  validator: (values) => (values == null || values.isEmpty)
                      ? "Select session"
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
                          value: 'Basic',
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
                        value: 'Pro',
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
                onPressed: () async {
                  //
                  if (fileName != 'Update file' &&
                      _formState.currentState!.validate()) {
                    // fire storage
                    var fileName =
                        '${_contentTitleController.text.replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), '_')}_${_contentSubtitleController.text.replaceAll(RegExp('[^A-Za-z0-9]'), '_')}_${DateTime.now().microsecond}.pdf';

                    //delete old file
                    await FirebaseStorage.instance
                        .refFromURL(widget.courseContentModel.fileUrl)
                        .delete();

                    // put new file
                    task = putFileToFireStorage(
                      file: selectedFile!,
                      name: fileName,
                    );

                    setState(() {});

                    if (task == null) return;
                    progressDialog(context, task!);

                    // download link
                    final snapshot = await task!.whenComplete(() {});
                    var downloadedUrl = await snapshot.ref.getDownloadURL();
                    print('link$downloadedUrl');

                    // update
                    await updateFileToFireStore(
                      fileUrl: downloadedUrl,
                    );

                    //
                    String localFile =
                        '${widget.courseContentModel.courseCode}_${widget.courseContentModel.contentTitle.replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), ' ')}_${widget.courseContentModel.contentSubtitle}_${widget.courseContentModel.contentId.toString().substring(0, 5)}.pdf';

                    //
                    final appStorage = Directory(
                        '/storage/emulated/0/Download/Campus Assistant');

                    final file = File('${appStorage.path}/$localFile');
                    await file.delete();

                    //
                    Navigator.pop(this.context);
                  } else {
                    await updateFileToFireStore(
                      fileUrl: widget.courseContentModel.fileUrl,
                    );
                  }
                },
                label: const Text('Update File')),
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
      final name = result.files.first.name;
      final path = result.files.first.path!;
      // fileType = result.files.first.extension;
      // print(fileType);

      setState(() {
        fileName = name;
        //
        selectedFile = File(path);
      });
    } else {
      // User canceled the picker
    }
  }

  // upload file to storage
  UploadTask? putFileToFireStorage({required File file, required String name}) {
    if (selectedFile == null) return null;

    var path =
        'Study/${widget.userModel.university}/${widget.courseContentModel.contentType}/$name';

    try {
      final ref = FirebaseStorage.instance.ref(path);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
      return null;
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

  // upload file to fire store
  updateFileToFireStore({required String fileUrl}) async {
    //
    var ref = FirebaseFirestore.instance
        .collection("Universities")
        .doc(widget.userModel.university)
        .collection('Departments')
        .doc(widget.userModel.department)
        .collection(widget.courseContentModel.contentType)
        .doc(widget.courseContentModel.contentId);

    //
    await ref.update(
      {
        'contentTitle': _contentTitleController.text.trim(),
        'contentSubtitle': _contentSubtitleController.text.trim(),
        'sessionList': _selectedSessionList,
        'fileUrl': fileUrl,
        'status': _selectedStatus,
      },
    );

    //
    if (!mounted) return;
    Navigator.pop(context);
  }
}

// content subtitle
getContentSubtitle({required String courseType}) {
  switch (courseType) {
    case 'Notes':
      {
        return 'Creator';
      }
    case 'Books':
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
