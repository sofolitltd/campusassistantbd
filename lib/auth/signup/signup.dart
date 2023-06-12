import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '/auth/student_dashboard.dart';
import '../../../models/user_model.dart';

class Signup extends StatefulWidget {
  const Signup({
    Key? key,
    required this.uid,
    required this.university,
    required this.department,
    required this.batch,
    required this.id,
    required this.session,
    required this.name,
    required this.phone,
    required this.selectedHall,
    required this.bloodGroup,
    required this.image,
  }) : super(key: key);

  final String uid;
  final String university;
  final String department;
  final String batch;
  final String id;
  final String session;
  final String name;
  final String phone;
  final String selectedHall;
  final String bloodGroup;
  final XFile? image;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  XFile? _pickedImage;

  UploadTask? task;
  bool isTaskActive = false;

  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.mail_outline_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      // suffixIcon: regExp.hasMatch(_emailController.text)
                      //     ? const Icon(Icons.check, color: Colors.green)
                      //     : const Icon(Icons.check),
                    ),
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

                  //password
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_open_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(_isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.remove_red_eye_outlined)),
                    ),
                    obscureText: _isObscure,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter your password';
                      } else if (val.length < 8) {
                        return 'Password at least 8 character';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            //
                            if (_globalKey.currentState!.validate()) {
                              setState(() => _isLoading = true);

                              //
                              await createNewUser(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text('Sign Up'.toUpperCase()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //

  // createNewUser
  createNewUser({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => null);

      //
      var user = userCredential.user;
      // log(user);

      if (user != null) {
        // 1
        await uploadImageFile(user);

        //
        setState(() => _isLoading = false);

        //
        if (!mounted) return null;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const StudentDashboard()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: 'Registration failed');
        setState(() => _isLoading = false);
      }

      //
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() => _isLoading = false);
        //
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign up Error'),
            content: const Text('The account already exists for that email.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          ),
        );
        // Fluttertoast.showToast(
        //     msg: 'The account already exists for that email.');
      }
      // Fluttertoast.showToast(msg: '${e.message}');
      log('${e.message}');
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: 'Some thing wrong.');
      log(e.toString());
    }
  }

  // upload and download url
  Future uploadImageFile(User user) async {
    final filePath = 'Users/${widget.university}/${widget.department}';
    final destination = '$filePath/${widget.id}.jpg';

    task = FirebaseStorage.instance
        .ref(destination)
        .putFile(File(_pickedImage!.path));
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    var downloadedUrl = await snapshot.ref.getDownloadURL();
    // log('Download-Link: $downloadedUrl');

    // cloud fire store
    await addUserInformation(user, downloadedUrl);
  }

  //
  addUserInformation(User user, String downloadedUrl) async {
    // await FirebaseMessaging.instance.getToken().then(
    //   (token) async {
    //
    UserModel userModel = UserModel(
      university: widget.university,
      department: widget.department,
      batch: widget.batch,
      id: widget.id,
      session: widget.session,
      name: widget.name,
      email: user.email!,
      phone: widget.phone,
      blood: widget.bloodGroup,
      hall: widget.selectedHall,
      status: 'Basic',
      imageUrl: downloadedUrl,
      role: {
        'admin': false,
        'cr': false,
      },
      uid: user.uid,
      deviceToken: '',
    );

    //
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .set(userModel.toJson());
    // },
    // );

    //
    await updateVerificationToken(user, downloadedUrl);
  }

  // update student info
  updateVerificationToken(User user, String downloadUrl) async {
    //
    await FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
        .collection('Departments')
        .doc(widget.department)
        .collection('Students')
        .doc('Batches')
        .collection(widget.batch)
        .doc(widget.id)
        .update({
      'email': user.email,
      'blood': widget.bloodGroup,
      'hall': widget.selectedHall,
      'phone': widget.phone,
      'token': 'USED',
      'imageUrl': downloadUrl,
    }).whenComplete(
      () {
        log('Remove Token successfully');
      },
    );

    // delete verification
    var ref = FirebaseFirestore.instance
        .collection('Verification')
        .doc(widget.uid)
        .delete();
  }
}
