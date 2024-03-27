import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/widgets/common_text_field_widget.dart';
import 'new_home_screen.dart';

class NewTeacherSignupScreen extends StatefulWidget {
  const NewTeacherSignupScreen({
    super.key,
    required this.university,
    required this.department,
    required this.profession,
    required this.name,
    required this.information,
    required this.verificationUID,
  });

  final String university;
  final String department;
  final String profession;
  final String name;
  final String verificationUID;
  final Map<dynamic, dynamic> information;

  @override
  State<NewTeacherSignupScreen> createState() => _NewTeacherSignupScreenState();
}

class _NewTeacherSignupScreenState extends State<NewTeacherSignupScreen> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.name;
    _mobileController.text = widget.information['mobile'];
    _emailController.text = widget.information['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.profession} Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Hello Sir'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                        ),
                        Text(
                          'Please sign up your account',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.w100,
                                  ),
                        ),

                        const SizedBox(height: 24),

                        CommonTextFieldWidget(
                          controller: _nameController,
                          heading: 'Name',
                          hintText: 'Enter full name',
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter your name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        CommonTextFieldWidget(
                          controller: _mobileController,
                          heading: 'Mobile',
                          hintText: 'Enter mobile number',
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter mobile number';
                            }
                            if (val.length < 11) {
                              return 'Mobile number at least 11 digits';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        CommonTextFieldWidget(
                          controller: _emailController,
                          heading: 'Email',
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter your email';
                            } else if (!regExp.hasMatch(val)) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        CommonTextFieldWidget(
                          heading: 'Password',
                          controller: _passwordController,
                          hintText: 'Enter new password',
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter your password';
                            } else if (val.length < 8) {
                              return 'Password at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        const Text(
                            '*Please remember this email and password for further login.'),

                        const SizedBox(height: 24),

                        //log in
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

                                    // register user
                                    await createNewUser(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );

                                    // register user
                                    await createNewUser(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    );

                                    //delete ver code
                                    await deleteVerificationToken();

                                    //
                                    if (!mounted) return;
                                    //
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NewHomeScreen()),
                                        (route) => false);
                                    log('Signup Successful');
                                    log('go to home');
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
                                  'Sign up'.toUpperCase(),
                                  style: const TextStyle(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // createNewUser
  createNewUser({required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //
      User? user = credential.user;
      if (user != null) {
        //
        await addUserInformation(user.uid);
        setState(() => _isLoading = false);
      } else {
        Fluttertoast.showToast(msg: 'Sign Up failed');
        setState(() => _isLoading = false);
      }

      // on exception
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
        log('The account already exists for that email.');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: 'Some thing wrong.');
      log('signup error: $e');
    }
  }

  //
  addUserInformation(String uid) async {
    var token = await FirebaseMessaging.instance.getToken();
    //
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {
        'uid': uid,
        'university': widget.university,
        'department': widget.department,
        'profession': widget.profession,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'information': {},
        'image': '',
        'token': token,
      },
    ).then((value) async {
      setState(() => _isLoading = false);

      // stay login

      if (!mounted) return;
      //
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NewHomeScreen()),
          (route) => false);
    });
    log('Signup successful');

    //
  }

  // delete verification

  Future<void> deleteVerificationToken() async {
    try {
      await FirebaseFirestore.instance
          .collection('Universities')
          .doc(widget.university)
          .collection('Departments')
          .doc(widget.department)
          .collection('Teachers')
          .where('code', isEqualTo: widget.verificationUID)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.update({'token': 'USED'}).then((_) {
            print('Update Token successfully');
          });
        });
      });

      await FirebaseFirestore.instance
          .collection('verifications')
          .doc(widget.verificationUID)
          .delete();
    } catch (e) {
      print('Error deleting verification token: $e');
      // Handle error as needed
    }
  }
}
