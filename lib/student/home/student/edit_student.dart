import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/student_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/constants.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({
    Key? key,
    required this.userModel,
    required this.selectedBatch,
    required this.studentModel,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedBatch;
  final StudentModel studentModel;

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  List hallList = [];
  String? _selectedHall;
  String? _selectedBloodGroup;
  String _selectedOrderBy = kStudentStatus[0];
  bool _isLoading = false;

  @override
  void initState() {
    getHallList();

    _nameController.text = widget.studentModel.name;
    _idController.text = widget.studentModel.id;
    _emailController.text = widget.studentModel.email;
    _phoneController.text = widget.studentModel.phone;
    _selectedHall = widget.studentModel.hall;
    _selectedOrderBy = (widget.studentModel.orderBy) == 1
        ? kStudentStatus[0]
        : kStudentStatus[1];
    //
    if (widget.studentModel.blood.isNotEmpty) {
      _selectedBloodGroup = widget.studentModel.blood;
    }

    super.initState();
  }

  // get hall
  getHallList() {
    FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.userModel.university)
        .collection('Departments')
        .doc(widget.userModel.department)
        .collection('Halls')
        .orderBy('name')
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() => hallList.add(doc.get('name')));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.userModel.university)
        .collection('Departments')
        .doc(widget.userModel.department)
        .collection('Students')
        .doc('Batches')
        .collection(widget.selectedBatch);

    //
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Student(${widget.selectedBatch})'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ButtonTheme(
          alignedDropdown: true,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 800
                  ? MediaQuery.of(context).size.width * .2
                  : 16,
              vertical: 16,
            ),
            children: [
              //name
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Name',
                  prefixIcon: const Icon(Icons.person_pin_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              //id
              TextFormField(
                controller: _idController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter student id';
                  }
                  // else if (value.length < 8 || value.length > 8) {
                  //   return 'Student id at least 8 digits';
                  // }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Student ID',
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.ac_unit_outlined),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              //email
              TextFormField(
                controller: _emailController,
                // validator: (value) => value!.isEmpty ? 'Enter email' :null,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              //phone
              TextFormField(
                controller: _phoneController,
                // validator: (value) => (value!.isEmpty)?'Enter phone no': null,
                decoration: const InputDecoration(
                  hintText: 'Phone',
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.call_outlined),
                ),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              // hall
              DropdownButtonFormField(
                isExpanded: true,
                value: _selectedHall,
                hint: const Text('Choose Hall'),
                // isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                  prefixIcon: Icon(Icons.home_work_outlined),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _selectedHall = value;
                  });
                },
                validator: (value) => value == null ? "Select your hall" : null,
                items: hallList.map((val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),

              //

              const SizedBox(height: 16),

              // order by
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: _selectedOrderBy,
                  hint: const Text('Student status'),
                  // isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                    prefixIcon: Icon(Icons.outbond_outlined),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedOrderBy = value!;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Select student status" : null,
                  items: kStudentStatus.map((String val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              //blood
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  value: _selectedBloodGroup,
                  hint: const Text('Blood Group'),
                  // isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 18, horizontal: 4),
                    prefixIcon: Icon(Icons.bloodtype_outlined),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedBloodGroup = value;
                    });
                  },
                  // validator: (value) =>
                  //     value == null ? "Select your blood group" : null,
                  items: kBloodGroup.map((String val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val,
                      ),
                    );
                  }).toList(),
                ),
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
                            StudentModel studentModel = StudentModel(
                              name: _nameController.text.trim(),
                              id: _idController.text.trim(),
                              hall: _selectedHall.toString(),
                              phone: _phoneController.text.isEmpty
                                  ? ''
                                  : _phoneController.text.trim(),
                              email: _emailController.text.isEmpty
                                  ? ''
                                  : _emailController.text.trim(),
                              blood: _selectedBloodGroup == null
                                  ? ''
                                  : _selectedBloodGroup!,
                              imageUrl: widget.studentModel.imageUrl,
                              token: widget.studentModel.token,
                              //regular = 1, irregular = 2,
                              orderBy:
                                  _selectedOrderBy == kStudentStatus[0] ? 1 : 2,
                            );

                            //
                            await ref
                                .doc(_idController.text.trim())
                                .set(studentModel.toJson())
                                .then((value) {
                              setState(() => _isLoading = false);

                              if (widget.studentModel.id !=
                                  _idController.text) {
                                ref.doc(widget.studentModel.id).delete();
                              }
                              //
                              Navigator.pop(context);
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
