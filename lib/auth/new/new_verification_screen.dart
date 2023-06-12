import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/auth/new/get_verification_code_screen.dart';
import '/auth/new/new_teacher_signup_screen.dart';
import '/auth/new/widgets/common_text_field_widget.dart';
import 'new_student_sign_up_screen.dart';

class NewVerificationScreen extends StatefulWidget {
  const NewVerificationScreen({Key? key}) : super(key: key);

  @override
  State<NewVerificationScreen> createState() => _NewVerificationScreenState();
}

class _NewVerificationScreenState extends State<NewVerificationScreen> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool _isLoading = false;
  List<String> hallList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _globalKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .3
                    : 16,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  Card(
                    elevation: 6,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Have a verification code'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                          ),
                          const Divider(height: 8),
                          Text(
                            'Enter your verification code to create new account.',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(),
                          ),

                          const SizedBox(height: 16),

                          CommonTextFieldWidget(
                            controller: _verificationCodeController,
                            heading: 'Verification Code',
                            hintText: 'Enter verification code',
                            keyboardType: TextInputType.number,
                            // autofocus: true,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Enter your verification code';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          //verify
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48)),
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_globalKey.currentState!.validate()) {
                                      setState(() => _isLoading = true);
                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      // code
                                      String enteredCode =
                                          _verificationCodeController.text
                                              .trim();
                                      String onlineCode = '';

                                      //
                                      String university = '';
                                      String department = '';
                                      String profession = '';
                                      String name = '';
                                      Map<dynamic, dynamic> information = {};

                                      //
                                      await FirebaseFirestore.instance
                                          .collection('verifications')
                                          .where('code', isEqualTo: enteredCode)
                                          .get()
                                          .then(
                                        (user) {
                                          for (var data in user.docs) {
                                            if (data.exists) {
                                              onlineCode = data.get('code');
                                              name = data.get('name');
                                              profession =
                                                  data.get('profession');
                                              information =
                                                  data.get('information');

                                              //
                                              university =
                                                  data.get('university');
                                              department =
                                                  data.get('department');
                                              log('code: $onlineCode');
                                              setState(() {});
                                            } else {
                                              onlineCode = '';
                                              log('email: $onlineCode');
                                            }
                                          }
                                        },
                                      );

                                      if (enteredCode == onlineCode) {
                                        log('code matched: $onlineCode');

                                        // if - teacher
                                        if (profession == 'teacher') {
                                          if (!mounted) return;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return NewTeacherSignupScreen(
                                                  university: university,
                                                  department: department,
                                                  profession: profession,
                                                  name: name,
                                                  information: information,
                                                );
                                              },
                                            ),
                                          );

                                          //
                                          setState(() => _isLoading = false);

                                          //if - student
                                        } else if (profession == 'student') {
                                          //get hall list
                                          hallList.clear();

                                          //
                                          var ref = FirebaseFirestore.instance
                                              .collection('Universities')
                                              .doc(university)
                                              .collection('Halls')
                                              .orderBy('name');

                                          //
                                          await ref.get().then(
                                            (QuerySnapshot snapshot) {
                                              for (var data in snapshot.docs) {
                                                hallList.add(data.get('name'));
                                                setState(() {});
                                              }
                                            },
                                          );

                                          // log(hallList.toString());
                                          //
                                          if (!mounted) return;
                                          setState(() => _isLoading = false);
                                          //
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return NewStudentSignUpScreen(
                                                university: university,
                                                department: department,
                                                profession: profession,
                                                name: name,
                                                information: information,
                                                hallList: hallList,
                                              );
                                            },
                                          ));

                                          //
                                        }
                                      } else {
                                        log('no user');
                                        if (!mounted) return;
                                        setState(() => _isLoading = false);

                                        //
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                              'Code not match! Please check your code or get you code.'),
                                          action: SnackBarAction(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const GetVerificationCodeScreen()));
                                            },
                                            label: 'Get code',
                                          ),
                                        ));
                                      }
                                    }
                                  },
                            child: _isLoading
                                ? const SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Verify now'.toUpperCase(),
                                    style: const TextStyle(
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  //
                  Card(
                    elevation: 6,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Don\'t have a verification code?'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                          ),

                          const SizedBox(height: 16),

                          //
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GetVerificationCodeScreen()));
                            },
                            child: Text(
                              'get your verification code!'.toUpperCase(),
                              style: const TextStyle(
                                letterSpacing: .2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// get info
getHallList({
  required String university,
  required String department,
  required String collectionName,
}) async {
  List<String> infoList = [];
  var ref = FirebaseFirestore.instance
      .collection('Universities')
      .doc(university)
      .collection('Departments')
      .doc(department)
      .collection(collectionName)
      .orderBy('name');
  log(ref.toString());

  //
  await ref.get().then(
    (QuerySnapshot snapshot) {
      for (var data in snapshot.docs) {
        infoList.add(data.get('name'));
      }
    },
  );
  log(infoList.toString());
  return infoList;
}
