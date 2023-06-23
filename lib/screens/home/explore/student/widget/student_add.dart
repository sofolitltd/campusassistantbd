import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/student_model.dart';
import '/utils/constants.dart';
import '/utils/create_verification_code.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({
    super.key,
    required this.university,
    required this.department,
    required this.selectedBatch,
  });

  final String university;
  final String department;
  final String selectedBatch;

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  List hallList = [];
  List sessions = [];
  String _selectedHall = 'None';
  String? _selectedSession;
  String? _selectedBloodGroup;
  String _selectedOrderBy = kStudentStatus[0];
  bool _isLoading = false;

  @override
  void initState() {
    getHalls();
    getSessions();
    super.initState();
  }

  // get halls
  getHalls() async {
    await FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
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

  //get sessions
  getSessions() async {
    await FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
        .collection('Departments')
        .doc(widget.department)
        .collection('sessions')
        .orderBy('name', descending: true)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() => sessions.add(doc.get('name')));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
        .collection('Departments')
        .doc(widget.department)
        .collection('students')
        .doc('batches')
        .collection(widget.selectedBatch);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Add Student(${widget.selectedBatch})',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              widget.department,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
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

              //id , session
              Row(
                children: [
                  //id
                  Expanded(
                    child: TextFormField(
                      controller: _idController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter student id';
                        }
                        if (value.length < 4) {
                          return 'Enter valid id';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Student ID',
                        labelText: 'Student ID',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  const SizedBox(width: 16),

                  //session
                  Expanded(
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: _selectedSession,
                      hint: const Text('Session'),
                      // isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedSession = value!;
                        });
                      },
                      validator: (value) =>
                          value == null ? "Select session" : null,
                      items: sessions.map((val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(
                            val,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
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
                hint: const Text('Select Hall'),
                // isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                  prefixIcon: Icon(Icons.home_work_outlined),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _selectedHall = value!;
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

              //order by
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: _selectedOrderBy,
                  hint: const Text('Student Status'),
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

                            String id = _idController.text.trim();
                            String code = createToken();

                            // check student already exist
                            await ref.doc(id).get().then((value) async {
                              if (value.exists) {
                                Fluttertoast.showToast(
                                    msg: 'Student ID already exist');
                                setState(() => _isLoading = false);
                              } else {
                                dev.log('Add new Student ID');

                                // check code already exist
                                await FirebaseFirestore.instance
                                    .collection('verifications')
                                    .doc(code)
                                    .get()
                                    .then((element) {
                                  if (element.exists) {
                                    String newCode = createToken();
                                    code = newCode;
                                    dev.log('New Code: $code');
                                  } else {
                                    dev.log('Old Code: $code');
                                  }
                                });

                                //
                                StudentModel studentModel = StudentModel(
                                  name: _nameController.text.trim(),
                                  id: _idController.text.trim(),
                                  session: _selectedSession!,
                                  hall: _selectedHall,
                                  phone: _phoneController.text.isEmpty
                                      ? ''
                                      : _phoneController.text.trim(),
                                  email: _emailController.text.isEmpty
                                      ? ''
                                      : _emailController.text.trim(),
                                  blood: _selectedBloodGroup == null
                                      ? ''
                                      : _selectedBloodGroup!,
                                  imageUrl: '',
                                  token: code,
                                  //regular = 1, irregular = 2,
                                  orderBy: _selectedOrderBy == kStudentStatus[0]
                                      ? 1
                                      : 2,
                                );

                                // add to /students/batches
                                await ref
                                    .doc(id)
                                    .set(studentModel.toJson())
                                    .then((value) async {
                                  //add to /verifications
                                  await FirebaseFirestore.instance
                                      .collection('verifications')
                                      .doc(code)
                                      .set({
                                    'university': widget.university,
                                    'department': widget.department,
                                    'profession': 'student',
                                    'code': code,
                                    'name': _nameController.text.trim(),
                                    'information': {
                                      'batch': widget.selectedBatch,
                                      'id': _idController.text.trim(),
                                      'session': _selectedSession,
                                      'hall': _selectedHall,
                                      'blood': _selectedBloodGroup ?? '',
                                    }
                                  }).then((value) {
                                    setState(() => _isLoading = false);
                                    Navigator.pop(context);
                                  });
                                });
                              }
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text('Upload now'.toUpperCase()))
            ],
          ),
        ),
      ),
    );
  }
}
