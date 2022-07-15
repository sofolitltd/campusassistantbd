import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../../../models/user_model.dart';
import '../../../utils/constants.dart';

class AddYearOrSemester extends StatefulWidget {
  const AddYearOrSemester({Key? key, required this.userModel})
      : super(key: key);
  final UserModel userModel;

  @override
  State<AddYearOrSemester> createState() => _AddYearOrSemesterState();
}

class _AddYearOrSemesterState extends State<AddYearOrSemester> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _creditsController = TextEditingController();
  final TextEditingController _coursesController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();

  List<String>? _selectedSessionList;
  bool _isLoading = false;

  @override
  void initState() {
    _selectedSessionList = kSessionList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Year or Semester'),
        centerTitle: true,
      ),
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
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Year or Semester',
                    hintText: '1st Year or 1st Semester',
                    // prefixIcon: const Icon(Icons.person_pin_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter year';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                //total credits
                TextFormField(
                  controller: _creditsController,
                  keyboardType: TextInputType.number,
                  // textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Total Credits',
                    hintText: '40',
                    // prefixIcon: const Icon(Icons.person_pin_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter total credits';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                //total courses
                TextFormField(
                  controller: _coursesController,
                  keyboardType: TextInputType.number,
                  // textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Total Courses',
                    hintText: '12',
                    // prefixIcon: const Icon(Icons.person_pin_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter total courses';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                //total marks
                TextFormField(
                  controller: _marksController,
                  keyboardType: TextInputType.number,
                  // textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Total Marks',
                    hintText: '1000',
                    // prefixIcon: const Icon(Icons.person_pin_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Enter total years';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // batch list
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
                      ? "Select something"
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

                              var ref = FirebaseFirestore.instance
                                  .collection('Universities')
                                  .doc(widget.userModel.university)
                                  .collection('Departments')
                                  .doc(widget.userModel.department)
                                  .collection('YearSemester');

                              await ref.doc().set({
                                'name': _nameController.text.trim(),
                                'credits': _creditsController.text.trim(),
                                'courses': _coursesController.text.trim(),
                                'marks': _marksController.text.trim(),
                                'sessionList': _selectedSessionList,
                              }).then((value) {
                                setState(() => _isLoading = false);

                                //
                                Navigator.pop(context);
                              });
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Save')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
