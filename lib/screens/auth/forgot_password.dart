import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Forgot Password
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailField = TextEditingController();
  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

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
      body: //email
          Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailField,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter your email';
                  } else if (!regExp.hasMatch(val)) {
                    return 'Enter valid email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
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
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: _emailField.text.trim());

                          //
                          Fluttertoast.showToast(
                              msg: 'Password reset email sent to your email');

                          setState(() => _isLoading = false);

                          //
                          Navigator.pop(context);

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
                  ? const CircularProgressIndicator()
                  : const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
