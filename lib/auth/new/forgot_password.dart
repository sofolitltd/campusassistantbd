import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'widgets/common_text_field_widget.dart';

// Forgot Password
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Forgot password'),
        centerTitle: true,
      ),

      //
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .3
                : 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'We sent a link to your email',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),

              const SizedBox(height: 8),
              Text(
                'click the link and reset your password.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
              ),

              const SizedBox(height: 24),

              //
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

              const SizedBox(height: 24),

              //
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);

                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(
                                    email: _emailController.text.trim())
                                .then((value) {
                              //
                              Fluttertoast.showToast(
                                  msg:
                                      'Password reset email sent to your email');

                              setState(() => _isLoading = false); //
                              Navigator.pop(context);
                            });

                            //
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(const SnackBar(
                                    backgroundColor: Colors.red,
                                    content:
                                        Text('No user found for this email')));
                            }

                            //
                            Fluttertoast.showToast(msg: '${e.message}');
                            setState(() => _isLoading = false);
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
                        'Submit'.toUpperCase(),
                        style: const TextStyle(
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              const SizedBox(height: 32),
              Text(
                '* If you don\'t see the email in your inbox, check your spam folder.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
