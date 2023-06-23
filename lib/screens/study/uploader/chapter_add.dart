import 'package:campusassistant/models/course_model_new.dart';
import 'package:campusassistant/models/profile_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '/models/chapter_model.dart';

class AddChapter extends StatefulWidget {
  const AddChapter({
    Key? key,
    required this.profileData,
    required this.selectedYear,
    // required this.id,
    required this.courseModel,
    required this.courseType,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String selectedYear;
  // final String id;
  final CourseModelNew courseModel;
  final String courseType;
  final List<String> batches;

  @override
  State<AddChapter> createState() => _AddChapterState();
}

class _AddChapterState extends State<AddChapter> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  int? _selectedChapterNo;
  List<String>? _selectedBatches;

  final TextEditingController _chapterTitleController = TextEditingController();

  @override
  void initState() {
    _selectedBatches = widget.batches;
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
          title: const Text('Add Chapter'),
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
              widget.courseModel.courseCode,
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

                      // chapter
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formState.currentState!.validate()) {
                            //
                            ChapterModel courseLessonModel = ChapterModel(
                              courseCode: widget.courseModel.courseCode.trim(),
                              chapterNo: _selectedChapterNo!,
                              chapterTitle: _chapterTitleController.text.trim(),
                              batches: _selectedBatches!,
                            );

                            //
                            FirebaseFirestore.instance
                                .collection('Universities')
                                .doc(widget.profileData.university)
                                .collection('Departments')
                                .doc(widget.profileData.department)
                                .collection('chapters')
                                .doc()
                                .set(courseLessonModel.toJson());

                            //
                            Fluttertoast.showToast(msg: 'Upload successfully');

                            //
                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text('upload'.toUpperCase()))),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  // top path
  buildPathSection(String year, courseCategory, courseCode, chapter) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Icon(
            Icons.account_tree_outlined,
            color: Colors.black87,
            size: 18,
          ),
        ),

        // year
        Expanded(
          child: Wrap(
            runAlignment: WrapAlignment.center,
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(width: .5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(year)),

              //
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('  $courseCategory '),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('/ $courseCode '),
              ),

              //
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('/ $chapter '),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//
