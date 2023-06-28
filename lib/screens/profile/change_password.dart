import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Change Password'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .2
                : 16,
            vertical: 16,
          ),
          children: [
            // title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text(
                'Old password',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            //old password
            TextFormField(
              controller: _oldPasswordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                hintText: '********',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscureOld = !_isObscureOld;
                      });
                    },
                    icon: Icon(_isObscureOld
                        ? Icons.visibility_off_outlined
                        : Icons.remove_red_eye_outlined)),
              ),
              obscureText: _isObscureOld,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter your password';
                } else if (val.length < 8) {
                  return 'Password at least 8 character';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text(
                'New password',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            //new password
            TextFormField(
              controller: _newPasswordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                hintText: '********',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscureNew = !_isObscureNew;
                      });
                    },
                    icon: Icon(_isObscureNew
                        ? Icons.visibility_off_outlined
                        : Icons.remove_red_eye_outlined)),
              ),
              obscureText: _isObscureNew,
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

            // signup
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      //
                      if (_globalKey.currentState!.validate()) {
                        setState(() => _isLoading = true);

                        //
                        await changePassword(
                          oldPassword: _oldPasswordController.text.trim(),
                          newPassword: _newPasswordController.text.trim(),
                        );
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  // change pass
  changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    //
    var currentUser = FirebaseAuth.instance.currentUser;

    //
    var credential = EmailAuthProvider.credential(
        email: currentUser!.email.toString(), password: oldPassword);

    //
    await currentUser.reauthenticateWithCredential(credential).then((value) {
      // change
      currentUser.updatePassword(newPassword);
      Fluttertoast.showToast(msg: 'Password change successfully');

      // login again
      loginWithEmail(
          email: currentUser.email.toString(), password: newPassword);
    }).catchError((error) {
      log(error.toString());
    });
  }

  // user login
  loginWithEmail({
    required String email,
    required String password,
  }) async {
    //
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
    });
  }
}
