//asifreyad1@gmail.com

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/screens/auth/signup1.dart';
import '/screens/dashboard/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  //
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Scaffold(
        body: SafeArea(
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
                child: Container(
                  padding: EdgeInsets.all(width * .05),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Spacer(flex: 2),

                        //
                        Text(
                          'Welcome Back',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),

                        const SizedBox(height: 16),

                        const Spacer(flex: 5),

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

                        // const SizedBox(height: 8),

                        //forgot pass
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {},
                                child: const Text('Forgot Password?'))),

                        const SizedBox(height: 16),

                        //log in
                        ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    if (_globalKey.currentState!.validate()) {
                                      setState(() => _isLoading = true);

                                      //
                                      loginWithEmail(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim(),
                                        args: '',
                                      );
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
                                          const SignUpScreen1()));
                            },
                            child: const Text('Sign up')),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // user login
  loginWithEmail(
      {required String email,
      required String password,
      required String args}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      //
      var user = userCredential.user;

      if (user != null) {
        //
        // await FirebaseMessaging.instance.getToken().then(
        //   (token) async {
        //     await FirebaseFirestore.instance
        //         .collection('Users')
        //         .doc(user.uid)
        //         .update({'deviceToken': token});
        //   },
        // );

        //
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false);

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
      Fluttertoast.showToast(msg: 'Some thing wrong.');
      print(e);
    }
  }
}
