import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/auth/forgot_password.dart';
import '/auth/new_home_screen.dart';
import '/auth/new_verification_screen.dart';
import '/widgets/common_text_field_widget.dart';
import '../widgets/app_logo.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _globalKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * .3
                    : 16,
                vertical: 16,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 350,
                    maxWidth: 400,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // logo
                      const AppLogo(),

                      const SizedBox(height: 32),

                      // login
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
                                'Welcome back'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                              ),
                              Text(
                                'login with email and password',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w100,
                                    ),
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

                              const SizedBox(height: 16),

                              CommonTextFieldWidget(
                                heading: 'Password',
                                controller: _passwordController,
                                hintText: 'Enter password',
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

                              const SizedBox(height: 24),

                              //log in
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 48)),
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        //todo: change !
                                        if (_globalKey.currentState!
                                            .validate()) {
                                          setState(() => _isLoading = true);

                                          //
                                          await loginWithEmail(
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text,
                                          );
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
                                        'Login'.toUpperCase(),
                                        style: const TextStyle(
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),

                              const SizedBox(height: 10),

                              //forgot pass
                              TextButton(
                                onPressed: () {
                                  //
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    bottom: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    ' Forgot Password ?',
                                    style: TextStyle(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // sign up
                      Card(
                        elevation: 6,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Don\'t have an account?'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                              ),
                              const SizedBox(height: 16),

                              //
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NewVerificationScreen()));
                                },
                                child: Text(
                                  'Create new account'.toUpperCase(),
                                  style: const TextStyle(
                                    letterSpacing: .5,
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
        ),
      ),
    );
  }

  // login
  loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //
      var user = userCredential.user;

      if (user != null) {
        // todo: use when work on notification

        await FirebaseMessaging.instance.getToken().then(
          (token) async {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              'token': token,
            });
          },
        );

        //
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NewHomeScreen()),
            (route) => false);

        //
        setState(() => _isLoading = false);
      } else {
        setState(() => _isLoading = false);
        log('No user found');
        Fluttertoast.showToast(msg: 'login failed: No user found');
      }
    } on FirebaseAuthException catch (e) {
      log('login error: $e');
      if (e.code == 'user-not-found') {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
      }
      Fluttertoast.showToast(msg: '${e.message}');
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: 'Some thing wrong.$e');
      log(e.toString());
    }
  }
}
