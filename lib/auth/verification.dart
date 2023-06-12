import 'package:campusassistant/auth/signup/signup3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'get_verification.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  //
  static const routeName = '/verification';

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool _isLoading = false;
  String _verifiedCode = '';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Verification'),
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

            // mobile
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(width * .05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'I have my verification code.',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      const SizedBox(height: 8),

                      //mobile
                      TextFormField(
                        controller: _verificationCodeController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter verification code';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: '12345678',
                          labelText: 'Enter verification code',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 20),

                      //
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_globalKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);

                                  //
                                  // await verification();

                                  var enteredCode =
                                      _verificationCodeController.text.trim();
                                  //
                                  var ref = await FirebaseFirestore.instance
                                      .collection('verifications')
                                      .where('code', isEqualTo: enteredCode)
                                      .get();
                                  for (var data in ref.docs) {
                                    if (data.exists) {
                                      String university =
                                          data.get('university');
                                      String department =
                                          data.get('department');
                                      String name = data.get('name');
                                      String profession =
                                          data.get('profession');

                                      String? batch;
                                      String? id;
                                      String? gender;

                                      if (profession == 'Teacher') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignUpScreen3(
                                              // uid: 'uid',
                                              university: university,
                                              department: department,
                                              batch: 'batch',
                                              // name: name,
                                              id: 'id',
                                              session: 'session',
                                              name: '',
                                              phone: '',
                                              selectedHall: '',
                                              bloodGroup: '',
                                              // hallList: [],
                                              // phone: '',
                                              // selectedHall: '',
                                              // bloodGroup: '',
                                              // image: null,
                                            ),
                                          ),
                                        );
                                      }

                                      //
                                      setState(() => _isLoading = false);
                                    }
                                    setState(() => _isLoading = false);
                                  }
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Verify now'),
                      ),

                      const SizedBox(height: 100),

                      Text(
                        'I don\'t have any code to verify?',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                          'Click below to get verification code and verify your studentship.'),

                      const SizedBox(height: 16),

                      //
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GetVerificationCode()));
                        },
                        icon: const Icon(Icons.help_outline_outlined),
                        label: const Text('How to get verification code?'),
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

  // verifyCode
  verification() async {
    var enteredCode = _verificationCodeController.text.trim();
    var ref = await FirebaseFirestore.instance
        .collection('verifications')
        .where('code', isEqualTo: enteredCode)
        .get();

    QueryDocumentSnapshot? data;
    for (data in ref.docs) {
      _verifiedCode = data.get('code');
      print(_verifiedCode);
    }

    if (enteredCode != _verifiedCode) {
      print('User not found in database...');
      Fluttertoast.showToast(
          msg: "User not found in database...\nContact with support!");
      setState(() => _isLoading = false);
    } else {
      print('user found');
      String code = data!.id;

      String university = data.get('university');
      String department = data.get('department');
      String name = data.get('name');
      String profession = data.get('profession');

      String? batch;
      String? id;
      String? gender;
      if (profession == 'Student') {
        String batch = data.get('information')['batch'];
        String id = data.get('information')['id'];
        String gender = data.get('information')['gender'];
        print('gender: $batch, $id');
      }

      //
      setState(() => _isLoading = false);

      //
      if (!mounted) return;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => Information(
      //       uid: 'uid',
      //       university: university,
      //       department: department,
      //       batch: 'batch',
      //       name: name,
      //       id: 'id',
      //       session: 'session',
      //       mobile: enteredCode,
      //     ),
      //   ),
      // );
    }
  }
}
