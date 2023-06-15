import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/student_model.dart';
import '/utils/constants.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({
    super.key,
    required this.university,
    required this.department,
    required this.selectedBatch,
    required this.studentModel,
  });

  final String university;
  final String department;
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

    _nameController.text = widget.studentModel.name;
    _idController.text = widget.studentModel.id;
    _selectedSession = widget.studentModel.session;
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

    //
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Edit Student(${widget.selectedBatch})',
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
                        enabled: false,
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

                            //
                            StudentModel studentModel = StudentModel(
                              name: _nameController.text.trim(),
                              id: _idController.text.trim(),
                              session: _selectedSession!,
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
                              //    delete old id
                              if (_idController.text.trim() !=
                                  widget.studentModel.id) {
                                ref.doc(widget.studentModel.id).delete();
                              }

                              // check code already exist
                              FirebaseFirestore.instance
                                  .collection('verifications')
                                  .doc(widget.studentModel.token)
                                  .get()
                                  .then((element) async {
                                if (element.exists) {
                                  log('Update verification');

                                  //
                                  await FirebaseFirestore.instance
                                      .collection('verifications')
                                      .doc(element.id)
                                      .update({
                                    'name': _nameController.text.trim(),
                                    'information': {
                                      'batch': widget.selectedBatch,
                                      'id': _idController.text.trim(),
                                      'session': _selectedSession,
                                      'hall': _selectedHall,
                                      'blood': _selectedBloodGroup ?? '',
                                    }
                                  });
                                } else {
                                  log('No verification Code');
                                }
                              });
                              setState(() => _isLoading = false);
                              //
                              Navigator.pop(context);
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text('Update'.toUpperCase()))
            ],
          ),
        ),
      ),
    );
  }
}
