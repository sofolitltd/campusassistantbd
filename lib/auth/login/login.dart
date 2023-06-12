import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/auth/verification.dart';
import '../../../teacher/teacher_dashboard.dart';
import '../new/forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  //
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// save data
setSharedData({required role, required university, required department}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('role', role);
  await prefs.setString('university', university);
  await prefs.setString('department', department);
}

class _LoginScreenState extends State<LoginScreen> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      // ),

      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width! * .05),
          child: width! > 800
              ? webView()

              //mobile
              : Form(
                  key: _globalKey,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * .96),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              const BackButton(),

                              //
                              Image.asset(
                                'assets/images/logo.png',
                                height: width! * .3,
                                width: width! * .3,
                              ),

                              //
                              Text(
                                'Welcome back',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),

                              //
                              // Text(
                              //   'User login',
                              //   style: Theme.of(context).textTheme.subtitle1,
                              // ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          //
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 16),

                              //email
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  prefixIcon:
                                      const Icon(Icons.mail_outline_outlined),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  // suffixIcon: regExp.hasMatch(_emailController.text.trim())
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
                                  prefixIcon:
                                      const Icon(Icons.lock_open_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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

                              // const SizedBox(height: 4),

                              //forgot pass
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
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
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Forgot Password ?'),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              //log in
                              ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          if (_globalKey.currentState!
                                              .validate()) {
                                            setState(() => _isLoading = true);

                                            await loginWithEmail(
                                              email:
                                                  _emailController.text.trim(),
                                              password:
                                                  _passwordController.text,
                                            );

                                            setState(() => _isLoading = false);
                                          }
                                        },
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('Log in')),

                              // or
                              Row(
                                children: const [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10),
                                    child: Text('or'),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),

                              // sign up
                              OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Verification()));
                                  },
                                  child: const Text('Create new account')),

                              const SizedBox(height: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // user login
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
                .collection('User')
                .doc(user.uid)
                .update({'token': token});
          },
        );

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TeacherDashboard()),
            (route) => false);

        //
        setState(() => _isLoading = false);
      } else {
        setState(() => _isLoading = false);
        print('No user found');
        Fluttertoast.showToast(msg: 'login failed: No user found');
      }
    } on FirebaseAuthException catch (e) {
      print('login error: $e');
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
      print(e.toString());
    }
  }

  //
  webView() {
    return Row(
      children: [
        //todo for web
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Image.asset(
              'assets/images/logo.png',
              height: width! * .2,
              width: width! * .2,
            ),
          ),
        ),

        //
        Expanded(
          child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  //email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.mail_outline_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      // suffixIcon: regExp.hasMatch(_emailController.text.trim())
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

                  // const SizedBox(height: 4),

                  //forgot pass
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        //
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Forgot Password ?'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  //log in
                  ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_globalKey.currentState!.validate()) {
                                setState(() => _isLoading = true);

                                //
                                // loginWithEmail(
                                //   email: _emailController.text.trim(),
                                //   password: _passwordController.text.trim(),
                                // );
                              }
                            },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Log in')),

                  // or
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                        child: Text('or'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  // sign up
                  OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Verification()));
                      },
                      child: const Text('Sign up')),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  //
  retryDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Not Email Found!',
          textAlign: TextAlign.start,
        ),
        content: const Text(
            'Email not found in database. Please check your email and try again.'),
        actionsPadding: const EdgeInsets.only(
          right: 16,
          bottom: 16,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Try again'),
            ),
          ),
        ],
      ),
    );
  }
}
