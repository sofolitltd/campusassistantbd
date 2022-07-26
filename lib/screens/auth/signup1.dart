import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/screens/auth/signup2.dart';

class SignUpScreen1 extends StatefulWidget {
  const SignUpScreen1({Key? key}) : super(key: key);

  //
  static const routeName = '/signup1';

  @override
  State<SignUpScreen1> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  List universityList = [];
  String? _selectedUniversity;
  String? _selectedDepartment;
  String? _selectedBatch;
  String? _selectedSession;

  bool _isLoading = false;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();

  @override
  void initState() {
    getUniversityList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Sign up'),
      ),
      body: Form(
        key: _globalKey,
        child: Row(
          children: [
            //
            if (width > 800)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: width * .2,
                    width: width * .2,
                  ),
                ),
              ),

            //
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(width * .05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // university list
                      DropdownButtonFormField(
                        isExpanded: true,
                        hint: const Text('Select your university'),
                        value: _selectedUniversity,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'University',
                        ),
                        items: universityList
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item,
                                    overflow: TextOverflow.ellipsis)))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedUniversity = null;
                            _selectedDepartment = null;
                            _selectedUniversity = value!;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'please select a university' : null,
                      ),

                      const SizedBox(height: 16),

                      // Departments
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Universities')
                            .doc(_selectedUniversity)
                            .collection('Departments')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Some thing went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // loading state
                            return DropdownButtonFormField(
                              hint: const Text('Select your department'),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Department',
                              ),
                              items: [].map((item) {
                                // university name
                                return DropdownMenuItem<String>(
                                    value: item, child: Text(item));
                              }).toList(),
                              onChanged: (String? value) {},
                              validator: (value) => value == null
                                  ? 'please select a department'
                                  : null,
                            );
                          }

                          var docs = snapshot.data!.docs;
                          // select department
                          return DropdownButtonFormField(
                            hint: const Text('Select your department'),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Department',
                            ),
                            value: _selectedDepartment,
                            items: docs.map((item) {
                              // university name
                              return DropdownMenuItem<String>(
                                  value: item.id, child: Text(item.id));
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedDepartment = value!;
                              });
                            },
                            validator: (value) => value == null
                                ? 'please select a department'
                                : null,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      //batches
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Universities')
                            .doc(_selectedUniversity)
                            .collection('Departments')
                            .doc(_selectedDepartment)
                            .collection('Batches')
                            .orderBy('name', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Some thing went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // loading state
                            return DropdownButtonFormField(
                              hint: const Text('Select your batch'),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Batch',
                              ),
                              items: [].map((item) {
                                // university name
                                return DropdownMenuItem<String>(
                                    value: item, child: Text(item));
                              }).toList(),
                              onChanged: (String? value) {},
                              validator: (value) => value == null
                                  ? 'please select your batch'
                                  : null,
                            );
                          }

                          var docs = snapshot.data!.docs;
                          //batch
                          return DropdownButtonFormField(
                            hint: const Text('Select your batch'),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Batch',
                            ),
                            value: _selectedBatch,
                            items: docs.map((item) {
                              // university name
                              return DropdownMenuItem<String>(
                                  value: item.get('name'),
                                  child: Text(item.get('name')));
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedBatch = value!;
                              });
                            },
                            validator: (value) => value == null
                                ? 'please select your batch'
                                : null,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      //session
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Universities')
                            .doc(_selectedUniversity)
                            .collection('Departments')
                            .doc(_selectedDepartment)
                            .collection('Sessions')
                            .orderBy('name', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Some thing went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // loading state
                            return DropdownButtonFormField(
                              hint: const Text('Select your session'),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Session',
                              ),
                              items: [].map((item) {
                                // university name
                                return DropdownMenuItem<String>(
                                    value: item, child: Text(item));
                              }).toList(),
                              onChanged: (String? value) {},
                              validator: (value) => value == null
                                  ? 'please select your session'
                                  : null,
                            );
                          }

                          var docs = snapshot.data!.docs;
                          //batch
                          return DropdownButtonFormField(
                            hint: const Text('Select your session'),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'session',
                            ),
                            value: _selectedSession,
                            items: docs.map((item) {
                              // university name
                              return DropdownMenuItem<String>(
                                  value: item.get('name'),
                                  child: Text(item.get('name')));
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedSession = value!;
                              });
                            },
                            validator: (value) => value == null
                                ? 'please select your session'
                                : null,
                          );
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
                        ),
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 16),

                      //verify
                      TextFormField(
                        controller: _verificationController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter verification code';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Verification Code',
                          labelText: 'Verification Code',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
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
                                  await verifyCode();
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // get university
  getUniversityList() {
    FirebaseFirestore.instance.collection('Universities').get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() => universityList.add(doc.id));
        }
      },
    );
  }

  // get info
  getUniversityInfo({
    required String university,
    required String department,
    required String listFor,
  }) async {
    List<String> infoList = [];
    await FirebaseFirestore.instance
        .collection('Universities')
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection(listFor)
        .orderBy('name')
        .get()
        .then(
      (QuerySnapshot snapshot) {
        for (var batch in snapshot.docs) {
          infoList.add(batch.get('name'));
        }
      },
    );
    return infoList;
  }

  // verifyCode
  verifyCode() async {
    await FirebaseFirestore.instance
        .collection('Universities')
        .doc(_selectedUniversity)
        .collection('Departments')
        .doc(_selectedDepartment)
        .collection('Students')
        .doc('Batches')
        .collection(_selectedBatch.toString())
        .doc(_idController.text)
        .get()
        .then(
      (DocumentSnapshot snapshot) async {
        if (!snapshot.exists) {
          print('id not found');
          Fluttertoast.showToast(msg: "Student ID not found in Database");
          setState(() => _isLoading = false);
        } else {
          print('id  found');
          var token = snapshot.get('token');

          if (token == _verificationController.text) {
            print("Verification Code Match");

            // hall
            List<String> hallList = await getUniversityInfo(
              university: _selectedUniversity.toString(),
              department: _selectedDepartment.toString(),
              listFor: 'Halls',
            );

            //
            setState(() => _isLoading = false);

            //
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen2(
                  university: _selectedUniversity.toString(),
                  department: _selectedDepartment.toString(),
                  batch: _selectedBatch.toString(),
                  session: _selectedSession.toString(),
                  id: _idController.text,
                  hallList: hallList,
                ),
              ),
            );

            //
          } else if (token == 'USED') {
            Fluttertoast.showToast(msg: "Verification code already used");
            //
            setState(() => _isLoading = false);
          } else {
            Fluttertoast.cancel();
            Fluttertoast.showToast(msg: "Wrong verify code. Enter correct one");
            setState(() => _isLoading = false);
          }
        }
      },
    );
  }
}
