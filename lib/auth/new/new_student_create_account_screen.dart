import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/profile_data.dart';
import 'new_home_screen.dart';
import 'widgets/common_text_field_widget.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({
    super.key,
    required this.university,
    required this.department,
    required this.profession,
    required this.name,
    required this.mobile,
    required this.batch,
    required this.id,
    required this.session,
    required this.hall,
    required this.blood,
  });

  final String university;
  final String department;
  final String profession;
  final String name;
  final String mobile;
  final String batch;
  final String id;
  final String session;
  final String hall;
  final String blood;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  File? _pickedMobileImage;
  Uint8List _webImage = Uint8List(8);
  bool isUpload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up(2/2)'),
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
                          'Create Account'.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: .2,
                                  ),
                        ),

                        Text(
                          'with email and password',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.w100,
                                  ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            //
                            _pickedMobileImage == null
                                ? Container(
                                    height: 116,
                                    width: 116,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade200,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'No image selected',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : Container(
                                    height: 116,
                                    width: 116,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.blueGrey.shade100),
                                      image: kIsWeb
                                          ? DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: MemoryImage(_webImage),
                                            )
                                          : DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: FileImage(
                                                  _pickedMobileImage!),
                                            ),
                                    ),
                                  ),

                            const SizedBox(width: 16),

                            //
                            Expanded(
                              child: SizedBox(
                                height: 116,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '* Choose a front facing image.'
                                      '\n* Try to use formal photo.',
                                      style: TextStyle(height: 1.2),
                                    ),

                                    //
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _pickedMobileImage == null
                                                ? Colors.deepPurple
                                                : Colors.red,
                                      ),
                                      onPressed: () async {
                                        await addImage();
                                      },
                                      child: Text(
                                        _pickedMobileImage == null
                                            ? 'Choose your Photo'.toUpperCase()
                                            : 'Change your Photo'.toUpperCase(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 24),

                        CommonTextFieldWidget(
                          controller: _emailController,
                          heading: 'Email',
                          hintText: 'Enter email',
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

                        const SizedBox(height: 10),

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
                            '* Please remember this email and password for further login.'),

                        const SizedBox(height: 24),

                        //log in
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48)),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_globalKey.currentState!.validate()) {
                                    if (_pickedMobileImage == null) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text('No image selected!'),
                                          content: const Text(
                                              'Please choose your photo first.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child:
                                                  Text('cancel'.toUpperCase()),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    const Size(150, 36),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                addImage();
                                              },
                                              child: Text(
                                                  'Choose photo'.toUpperCase()),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      setState(() => _isLoading = true);

                                      // register user
                                      await createNewUser(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      );
                                      //
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

  //add image
  addImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    // ImageCropper imageCropper = ImageCropper();
    //
    // CroppedFile? croppedImage = await imageCropper.cropImage(
    //   sourcePath: image!.path,
    //   cropStyle: CropStyle.circle,
    //   aspectRatioPresets: [
    //     CropAspectRatioPreset.original,
    //     CropAspectRatioPreset.square,
    //     CropAspectRatioPreset.ratio3x2,
    //     CropAspectRatioPreset.ratio4x3,
    //     CropAspectRatioPreset.ratio16x9
    //   ],
    //   uiSettings: [
    //     AndroidUiSettings(
    //       toolbarTitle: 'image Customization',
    //       toolbarColor: ThemeData().cardColor,
    //       toolbarWidgetColor: Colors.deepOrange,
    //       initAspectRatio: CropAspectRatioPreset.square,
    //       lockAspectRatio: false,
    //     )
    //   ],
    // );

    if (!kIsWeb) {
      if (image != null) {
        var selectedMobileImage = File(image.path);
        setState(() {
          _pickedMobileImage = selectedMobileImage;
        });
      }
    } else if (kIsWeb) {
      if (image != null) {
        var selectedWebImage = await image.readAsBytes();
        setState(() {
          _webImage = selectedWebImage;
          _pickedMobileImage = File('');
        });
      }
    }
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
        await uploadImage(user.uid);

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

  //upload image
  uploadImage(String uid) async {
    //
    var ref = FirebaseStorage.instance
        .ref('Users')
        .child(widget.university)
        .child(widget.department)
        .child('${widget.id}.jpg');
    var downloadedUrl = '';

    //
    if (kIsWeb) {
      await ref.putData(_webImage);
      downloadedUrl = await ref.getDownloadURL();
    } else {
      await ref.putFile(_pickedMobileImage!);
      downloadedUrl = await ref.getDownloadURL();
    }

    //
    await addUserInformation(uid, downloadedUrl);
  }

  //
  addUserInformation(String uid, downloadUrl) async {
    String? token = await FirebaseMessaging.instance.getToken();

    //
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(ProfileData(
          uid: uid,
          university: widget.university,
          department: widget.department,
          profession: widget.profession,
          name: widget.name,
          email: _emailController.text.trim(),
          mobile: widget.mobile,
          image: downloadUrl,
          information: Information(
            batch: widget.batch,
            id: widget.id,
            session: widget.session,
            hall: widget.hall,
            blood: widget.blood,
            status: Status(
              subscriber: 'basic',
              moderator: false,
              admin: false,
              cr: false,
            ),
          ),
          token: token!,
        ).toJson())
        .then(
      (value) async {
        if (!mounted) return;
        //
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NewHomeScreen()),
            (route) => false);
      },
    );
    log('Signup Successful');
  }
}
