import 'dart:developer';

import 'package:campusassistant/models/profile_data.dart';
import 'package:campusassistant/models/semester_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class EditSemester extends StatefulWidget {
  const EditSemester({
    Key? key,
    required this.profileData,
    required this.batches,
    required this.semester,
    required this.semesterId,
  }) : super(key: key);
  final ProfileData profileData;
  final List<String> batches;
  final SemesterModel semester;
  final String semesterId;

  @override
  State<EditSemester> createState() => _EditSemesterState();
}

class _EditSemesterState extends State<EditSemester> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _creditsController = TextEditingController();
  final TextEditingController _coursesController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();

  List<String>? _selectedBatch;
  bool _isLoading = false;

  @override
  void initState() {
    _titleController.text = widget.semester.title;
    _coursesController.text = widget.semester.courses;
    _creditsController.text = widget.semester.credits;
    _marksController.text = widget.semester.marks;
    _selectedBatch = widget.semester.batches.cast<String>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.profileData.university)
        .collection('Departments')
        .doc(widget.profileData.department)
        .collection('semesters');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Year or Semester'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // delete
              log('semesterId: ${widget.semesterId}');
              ref.doc(widget.semesterId).delete().then((value) {
                Navigator.pop(context);
              });
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),

      //
      body: Form(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .2
                  : 16,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                //Year or Semester
                TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(width: .5)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(width: .5)),
                    labelText: 'Year or Semester',
                    hintText: '1st Year or 1st Semester',
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter year or semester';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    //total courses
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _coursesController,
                        keyboardType: TextInputType.number,
                        // textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          labelText: 'Courses',
                          hintText: '12',
                          // prefixIcon: const Icon(Icons.person_pin_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(width: .5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(width: .5)),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter courses';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    //total credits
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _creditsController,
                        keyboardType: TextInputType.number,
                        // textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          labelText: 'Credits',
                          hintText: '40',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(width: .5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(width: .5)),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter credits';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    //total marks
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _marksController,
                        keyboardType: TextInputType.number,
                        // textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          labelText: 'Marks',
                          hintText: '1000',
                          // prefixIcon: const Icon(Icons.person_pin_outlined),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(width: .5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(width: .5)),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter marks';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // batch list
                MultiSelectDialogField(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  searchable: true,
                  selectedColor: Colors.blueAccent.shade100,
                  selectedItemsTextStyle: const TextStyle(color: Colors.black),
                  title: const Text('Batches'),
                  buttonText: const Text('Batches'),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  initialValue: _selectedBatch!,
                  items:
                      widget.batches.map((e) => MultiSelectItem(e, e)).toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (List<String> values) {
                    setState(() {
                      _selectedBatch = values;
                    });
                  },
                  validator: (values) => (values == null || values.isEmpty)
                      ? "Select batch"
                      : null,
                ),

                const SizedBox(height: 24),

                //
                ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_globalKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              //
                              await ref
                                  .doc(widget.semesterId)
                                  .update(SemesterModel(
                                    title: _titleController.text.trim(),
                                    courses: _coursesController.text.trim(),
                                    credits: _creditsController.text.trim(),
                                    marks: _marksController.text.trim(),
                                    batches: _selectedBatch!,
                                  ).toJson())
                                  .then((value) {
                                setState(() => _isLoading = false);

                                //
                                Navigator.pop(context);
                              });
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text('Update'.toUpperCase())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
