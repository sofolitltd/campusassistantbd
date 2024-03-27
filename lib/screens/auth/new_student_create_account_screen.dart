import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '/models/profile_data.dart';
import '/widgets/common_text_field_widget.dart';
import 'new_home_screen.dart';

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
    required this.verificationUID,
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
  final String verificationUID;

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
                                    Text(
                                      '* Try to use formal photo.'
                                      '\n* Female can use photo with Hijab & Nikab.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(height: 1.2),
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
                                        await pickImage(context);
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
                                    setState(() => _isLoading = true);

                                    //
                                    User? user;
                                    String downloadedUrl = '';

                                    // register user
                                    user = await createNewUser(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    );

                                    if (user?.uid != null) {
                                      // with out image
                                      if (_pickedMobileImage != null) {
                                        downloadedUrl =
                                            await uploadImage(user!.uid);
                                      }

                                      // add student info
                                      await addUserInformation(
                                          user!.uid, downloadedUrl);

                                      // update student info
                                      await updateStudentInformation(
                                          image: downloadedUrl);

                                      //delete ver code
                                      await deleteVerificationToken(
                                          downloadedUrl);

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
                                    }
                                  } else {
                                    log('No user');
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
  pickImage(context) async {
    // Pick an image
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    //
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: image!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 40,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        //android
        AndroidUiSettings(
          toolbarTitle: 'image Customization',
          toolbarColor: ThemeData().cardColor,
          toolbarWidgetColor: Colors.deepOrange,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),

        //web
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 350,
            height: 350,
          ),
          viewPort:
              const CroppieViewPort(width: 350, height: 350, type: 'square'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );

    if (!kIsWeb) {
      if (croppedImage != null) {
        var selectedMobileImage = File(croppedImage.path);
        setState(() {
          _pickedMobileImage = selectedMobileImage;
        });
      }
    } else if (kIsWeb) {
      if (croppedImage != null) {
        var selectedWebImage = await croppedImage.readAsBytes();
        setState(() {
          _webImage = selectedWebImage;
          _pickedMobileImage = File('');
        });
      }
    }
  }

  // createNewUser
  Future<User?> createNewUser(
      {required String email, required String password}) async {
    User? user;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //
      user = credential.user;
      if (user != null) {
        log("login uid: ${user.uid}");
      } else {
        await Fluttertoast.showToast(msg: 'Sign Up failed');
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
    return user;
  }

  //upload image
  Future<String> uploadImage(String uid) async {
    var downloadedUrl = '';

    //
    var ref = FirebaseStorage.instance
        .ref('Users')
        .child(widget.university)
        .child(widget.department)
        .child('${widget.id}.jpg');

    //
    if (kIsWeb) {
      await ref.putData(_webImage);
    } else {
      await ref.putFile(_pickedMobileImage!);
    }
    downloadedUrl = await ref.getDownloadURL();
    return downloadedUrl;
  }

  //
  addUserInformation(String uid, image) async {
    String? token = '';
    if (!kIsWeb) {
       token = await FirebaseMessaging.instance.getToken();
    }

    // add to user
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
          image: image,
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
        ).toJson());
  }

  //update student info
  updateStudentInformation({required String image}) async {
    await FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
        .collection('Departments')
        .doc(widget.department)
        .collection('students')
        .doc('batches')
        .collection(widget.batch)
        .doc(widget.id)
        .update({
      'email': _emailController.text.trim(),
      'phone': widget.mobile,
      'hall': widget.hall,
      'blood': widget.blood,
      'imageUrl': image,
    });
  }

  // delete verification
  deleteVerificationToken(String downloadUrl) async {
    await FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.university)
        .collection('Departments')
        .doc(widget.department)
        .collection('students')
        .doc('batches')
        .collection(widget.batch)
        .doc(widget.id)
        .update({
      'token': 'USED',
      'imageUrl': downloadUrl,
    }).then(
      (val) {
        log('Update Token successfully');
        FirebaseFirestore.instance
            .collection('verifications')
            .doc(widget.verificationUID)
            .delete();
      },
    );
  }
}
