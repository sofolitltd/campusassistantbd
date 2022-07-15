import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UploadFileEdit extends StatefulWidget {
  const UploadFileEdit({
    key,
    required this.fileUrl,
    required this.document,
    required this.ref,
  }) : super(key: key);

  final String fileUrl;
  final QueryDocumentSnapshot document;
  final CollectionReference ref;

  @override
  State<UploadFileEdit> createState() => _UploadFileEditState();
}

class _UploadFileEditState extends State<UploadFileEdit> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _fileTitleController = TextEditingController();
  final TextEditingController _fileSubtitleController = TextEditingController();

  String? fileName;
  File? selectedFile;
  UploadTask? task;

  @override
  void initState() {
    _fileTitleController.text = widget.document.get('title');
    _fileSubtitleController.text = widget.document.get('subtitle');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Edit File'),
      ),

      //
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //
          // Container(
          //   decoration: BoxDecoration(
          //       border: Border.all(color: Colors.grey),
          //       borderRadius: BorderRadius.circular(4)),
          //   child: ListTile(
          //     contentPadding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
          //     horizontalTitleGap: 0,
          //     shape: const RoundedRectangleBorder(),
          //     leading: const Icon(Icons.file_copy_outlined),
          //     title: fileName == null
          //         ? const Text('No File Selected',
          //             style: TextStyle(color: Colors.red))
          //         : SelectableText(
          //             fileName!,
          //             style: const TextStyle(),
          //           ),
          //     trailing: InkWell(
          //       onTap: () {
          //         pickFile();
          //       },
          //       child: Container(
          //           padding: const EdgeInsets.all(7),
          //           decoration: BoxDecoration(
          //               color: Colors.green,
          //               borderRadius: BorderRadius.circular(4)),
          //           child: const Icon(
          //             Icons.attach_file_outlined,
          //             color: Colors.white,
          //           )),
          //     ),
          //   ),
          // ),

          //
          // const SizedBox(height: 16),

          //
          Form(
            key: _formState,
            child: Column(
              children: [
                // title
                TextFormField(
                  controller: _fileTitleController,
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
                  controller: _fileSubtitleController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Creator',
                    hintText: 'Khadija Ujma(17-18)',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter Chapter Title" : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          //
          ElevatedButton(
              onPressed: () async {
                if (_formState.currentState!.validate()) {
                  // fire store
                  updateFileToFireStore();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload_outlined),
                    SizedBox(width: 8),
                    Text('Update File'),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // pick file
  // pickFile() async {
  //   //open file manager
  //   FilePickerResult? result = await FilePicker.platform
  //       .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
  //
  //   //
  //   if (result != null) {
  //     final name = result.files.first.name;
  //     final path = result.files.first.path!;
  //
  //     setState(() {
  //       fileName = name;
  //       //
  //       selectedFile = File(path);
  //     });
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  // upload file to storage
  // UploadTask? putFileToFireStorage({required File file, required String name}) {
  //   if (selectedFile == null) return null;
  //
  //   var path =
  //       'Study/${widget.year}/${widget.courseCode}/${widget.courseCategory}/$name';
  //
  //   try {
  //     final ref = FirebaseStorage.instance.ref(path);
  //     return ref.putFile(file);
  //   } on FirebaseException catch (e) {
  //     return null;
  //   }
  // }

  // show dialog
  // progressDialog(BuildContext context, UploadTask task) {
  //   FocusManager.instance.primaryFocus!.unfocus();
  //
  //   return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             contentPadding: const EdgeInsets.all(12),
  //             title: Stack(
  //               alignment: Alignment.centerRight,
  //               children: [
  //                 const SizedBox(
  //                   width: double.infinity,
  //                   child: Text(
  //                     'Uploading File',
  //                     style: TextStyle(fontSize: 16),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //
  //                 //
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Container(
  //                       padding: const EdgeInsets.all(4),
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: Colors.grey.shade100,
  //                       ),
  //                       child: const Icon(
  //                         Icons.close_outlined,
  //                         size: 20,
  //                       )),
  //                 ),
  //               ],
  //             ),
  //             titlePadding: const EdgeInsets.all(12),
  //             content: StreamBuilder<TaskSnapshot>(
  //                 stream: task.snapshotEvents,
  //                 builder: (context, snapshot) {
  //                   if (snapshot.hasData) {
  //                     final snap = snapshot.data!;
  //                     final progress = snap.bytesTransferred / snap.totalBytes;
  //                     final percentage = (progress * 100).toStringAsFixed(0);
  //                     return Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         ClipRRect(
  //                           borderRadius: BorderRadius.circular(32),
  //                           child: LinearProgressIndicator(
  //                             minHeight: 16,
  //                             value: progress,
  //                             valueColor: AlwaysStoppedAnimation<Color>(
  //                                 Colors.blueAccent.shade200),
  //                             backgroundColor: Colors.lightBlueAccent.shade100
  //                                 .withOpacity(.2),
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Text('$percentage %'),
  //                         const SizedBox(height: 8),
  //                       ],
  //                     );
  //                   } else {
  //                     return Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         ClipRRect(
  //                           borderRadius: BorderRadius.circular(32),
  //                           child: LinearProgressIndicator(
  //                             minHeight: 16,
  //                             valueColor: AlwaysStoppedAnimation<Color>(
  //                                 Colors.blueAccent.shade200),
  //                             backgroundColor: Colors.lightBlueAccent.shade100
  //                                 .withOpacity(.2),
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         const Text(' '),
  //                         const SizedBox(height: 8),
  //                       ],
  //                     );
  //                   }
  //                 }),
  //           ));
  // }

  // upload file to fire store
  updateFileToFireStore() async {
    //time
    String time = DateFormat('dd MMM, yyyy').format(DateTime.now());

    //
    await widget.ref.doc(widget.document.id).update({
      'title': _fileTitleController.text,
      'subtitle': _fileSubtitleController.text,
      'fileUrl': widget.document.get('fileUrl'),
      'date': time,
    }).whenComplete(() {
      Fluttertoast.showToast(msg: 'Update Successfully');
      Navigator.pop(context);
    });
  }
}
