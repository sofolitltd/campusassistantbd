import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '/models/chapter_model.dart';
import '/models/course_model.dart';
import '/models/user_model.dart';
import '/utils/constants.dart';
import '../../../services/database_service.dart';

class EditChapter extends StatefulWidget {
  const EditChapter({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    required this.courseModel,
    required this.courseType,
    required this.chapterModel,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final CourseModel courseModel;
  final ChapterModel chapterModel;
  final String courseType;

  @override
  State<EditChapter> createState() => _EditChapterState();
}

class _EditChapterState extends State<EditChapter> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _chapterTitleController = TextEditingController();

  int? _selectedChapterNo;
  List<dynamic>? _selectedSessionList;

  @override
  void initState() {
    _selectedChapterNo = widget.chapterModel.chapterNo;
    _chapterTitleController.text = widget.chapterModel.chapterTitle;
    _selectedSessionList = widget.chapterModel.sessionList;
    super.initState();
  }

  @override
  void dispose() {
    _chapterTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('Edit Chapter'),
          actions: [
            IconButton(
              onPressed: () async {
                print(widget.id);

                //
                await DatabaseService.refUniversities
                    .doc(widget.userModel.university)
                    .collection('Departments')
                    .doc(widget.userModel.department)
                    .collection('Chapters')
                    .doc(widget.id)
                    .delete()
                    .then((value) {
                  Navigator.pop(context);
                });
              },
              icon: const Icon(
                Icons.delete_outline_outlined,
              ),
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
            //top path
            buildPathSection(
              widget.selectedYear,
              widget.courseModel.courseCategory,
              'Psy ${widget.courseModel.courseCode}',
              'Chapters',
            ),

            const SizedBox(height: 16),

            //
            Form(
              key: _formState,
              child: Column(
                children: [
                  //
                  Row(
                    children: [
                      Expanded(child: Container()),

                      const SizedBox(width: 16),

                      //
                      Expanded(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            value: _selectedChapterNo,
                            hint: const Text('Chapter No'),
                            decoration: const InputDecoration(
                              label: Text('Chapter No'),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 8),
                            ),
                            onChanged: (int? value) {
                              setState(() {
                                _selectedChapterNo = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? "Choose Chapter No" : null,
                            items: List.generate(15, (index) => 1 + index++)
                                .map((int value) {
                              return DropdownMenuItem(
                                alignment: Alignment.center,
                                value: value,
                                child: Text(
                                  '$value',
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //
                  TextFormField(
                    controller: _chapterTitleController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Chapter Title',
                      hintText: 'Introduction',
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
                    selectedItemsTextStyle:
                        const TextStyle(color: Colors.black),
                    title: const Text('Session List'),
                    buttonText: const Text('Session List'),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    initialValue: _selectedSessionList,
                    items:
                        kSessionList.map((e) => MultiSelectItem(e, e)).toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (List<dynamic> values) {
                      setState(() {
                        _selectedSessionList = values;
                      });
                    },
                    validator: (values) => (values == null || values.isEmpty)
                        ? "Select session"
                        : null,
                  ),

                  const SizedBox(height: 16),

                  //
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formState.currentState!.validate()) {
                            //
                            ChapterModel courseLessonModel = ChapterModel(
                              courseCode: widget.courseModel.courseCode.trim(),
                              chapterNo: _selectedChapterNo!,
                              chapterTitle: _chapterTitleController.text.trim(),
                              sessionList: _selectedSessionList!,
                            );

                            //
                            await FirebaseFirestore.instance
                                .collection('Universities')
                                .doc(widget.userModel.university)
                                .collection('Departments')
                                .doc(widget.userModel.department)
                                .collection('Chapters')
                                .doc(widget.id)
                                .update(courseLessonModel.toJson())
                                .then(
                              (value) {
                                Fluttertoast.showToast(
                                    msg: 'Upload successfully');
                                Navigator.pop(context);
                              },
                            );
                          }
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text('Upload'.toUpperCase()))),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  // top path
  Wrap buildPathSection(String year, courseCategory, courseCode, chapter) {
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

        // year
        Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(width: .5, color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(year)),

        //
        const Icon(Icons.keyboard_arrow_right_rounded),
        Text(courseCategory),

        //
        const Icon(Icons.keyboard_arrow_right_rounded),
        Text(courseCode),

        //
        const Icon(Icons.keyboard_arrow_right_rounded),
        Text(chapter),
      ],
    );
  }
}

//
