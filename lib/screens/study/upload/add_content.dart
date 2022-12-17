import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:uuid/uuid.dart';

import '/models/content_model.dart';
import '/models/course_model.dart';
import '/models/user_model.dart';
import '../../../services/database_service.dart';
import '../../../utils/constants.dart';

///Study/2nd Year/Practical Course/Psy 207/Notes/Lessons/02/sxusycT5qFMLYx91ec1Z
class AddContent extends StatefulWidget {
  const AddContent({
    key,
    required this.userModel,
    required this.id,
    required this.selectedYear,
    required this.courseType,
    required this.courseModel,
    this.chapterNo,
  }) : super(key: key);

  final UserModel userModel;
  final String id;
  final String selectedYear;
  final String courseType;
  final CourseModel courseModel;
  final int? chapterNo;

  @override
  State<AddContent> createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
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
    _selectedSessionList = kSessionList;
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
        padding: const EdgeInsets.all(16),
        children: [
          //
          buildPathSection(
            year: widget.selectedYear,
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
                    labelText:
                        getContentSubtitle(courseType: widget.courseType),
                    // widget.courseType == 'Notes' ? 'Creator' : 'Year',
                    hintText: getContentSubtitle(courseType: widget.courseType),
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
                        },
                      ),
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
                  if (fileName == null) {
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(msg: 'No File Selected !');
                  } else if (_formState.currentState!.validate()) {
                    // fire storage
                    var fileName =
                        '${widget.courseModel.courseCode}_${_contentTitleController.text.replaceAll(RegExp('[^A-Za-z0-9]', dotAll: true), '_')}_${_contentSubtitleController.text.replaceAll(RegExp('[^A-Za-z0-9]'), '_')}_${DateTime.now().microsecond}.pdf';

                    //
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
                    // print('link$downloadedUrl');

                    // fire store
                    await uploadFileToFireStore(fileUrl: downloadedUrl);

                    //
                    Navigator.pop(this.context);
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

    ///Universities/University of Chittagong/Departments/Department of Psychology
    var path =
        'Universities/${widget.userModel.university}/${widget.userModel.department}/${widget.courseType}/$name';

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
                              backgroundColor: Colors.lightBlueAccent.shade100
                                  .withOpacity(.2),
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
                              backgroundColor: Colors.lightBlueAccent.shade100
                                  .withOpacity(.2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(' '),
                          const SizedBox(height: 8),
                        ],
                      );
                    }
                  }),
            ));
  }

  // upload file to fire store
  uploadFileToFireStore({required String fileUrl}) async {
    //time
    String uploadDate = DateFormat('dd MMM, yyyy').format(DateTime.now());

    // uid
    String contentId = const Uuid().v4();

    //
    ContentModel courseContentModel = ContentModel(
      contentId: contentId,
      courseCode: widget.courseModel.courseCode,
      contentType: widget.courseType,
      lessonNo: widget.courseType == 'Notes' ? widget.chapterNo! : 1,
      status: _selectedStatus,
      sessionList: _selectedSessionList!,
      contentTitle: _contentTitleController.text.trim(),
      contentSubtitle: _contentSubtitleController.text.trim(),
      contentSubtitleType: getContentSubtitle(courseType: widget.courseType),
      uploadDate: uploadDate,
      fileUrl: fileUrl,
      imageUrl: '',
      uploader:
          '${widget.userModel.name.split(' ').last}(${widget.userModel.session})',
    );

    //
    await DatabaseService.addCourseContent(
      university: widget.userModel.university,
      department: widget.userModel.department,
      year: widget.selectedYear,
      contentId: contentId,
      courseType: widget.courseType,
      courseContentModel: courseContentModel,
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
