import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '/utils/constants.dart';
import '../../../models/course_model_new.dart';
import '../../../models/profile_data.dart';

class EditCourse extends StatefulWidget {
  const EditCourse({
    Key? key,
    required this.profileData,
    required this.selectedSemester,
    required this.courseId,
    required this.courseModel,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
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
                  .doc(widget.profileData.university)
                  .collection('Departments')
                  .doc(widget.profileData.department)
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
                                  image: widget.courseModel.image,
                                );

                                // add course
                                await FirebaseFirestore.instance
                                    .collection('Universities')
                                    .doc(widget.profileData.university)
                                    .collection('Departments')
                                    .doc(widget.profileData.department)
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
}
