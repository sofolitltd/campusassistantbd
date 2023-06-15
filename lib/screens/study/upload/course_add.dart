import 'package:campusassistant/models/course_model_new.dart';
import 'package:campusassistant/models/profile_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '/utils/constants.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({
    Key? key,
    required this.profileData,
    required this.semester,
    required this.batches,
  }) : super(key: key);

  final ProfileData profileData;
  final String semester;
  final List<String> batches;

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
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
    _selectedBatches = widget.batches;
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
        title: const Text('Add Course'),
        elevation: 0,
        centerTitle: true,
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
            buildPathSection(widget.semester),

            const SizedBox(height: 16),

            //
            Form(
              key: _formState,
              child: Column(
                children: [
                  //todo: course [add image]

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
                            hintText: 'CODE 101',
                          ),
                          textCapitalization: TextCapitalization.characters,
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
                      const SizedBox(width: 8),
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
                    ],
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
                                  courseYear: widget.semester,
                                  courseCategory: _selectedCourseCategory!,
                                  courseCode: _courseCodeController.text
                                      .trim()
                                      .toUpperCase(),
                                  courseTitle:
                                      _courseTitleController.text.trim(),
                                  courseCredits:
                                      _courseCreditsController.text.trim(),
                                  courseMarks:
                                      _courseMarksController.text.trim(),
                                  batches: _selectedBatches!,
                                  image: '',
                                );

                                // add course
                                await FirebaseFirestore.instance
                                    .collection('Universities')
                                    .doc(widget.profileData.university)
                                    .collection('Departments')
                                    .doc(widget.profileData.department)
                                    .collection('courses')
                                    .doc()
                                    .set(courseModel.toJson());

                                Fluttertoast.showToast(
                                    msg: 'Upload successfully');

                                //
                                setState(() => _isLoading = false);

                                //
                                if (!mounted) return;
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Upload'.toUpperCase())),
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
        const Text('Add Course Information'),
      ],
    );
  }
}
