import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../auth/login/login.dart';
import '../auth/verification.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  //
  static const routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    //
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        FirebaseFirestore.instance.collection('User').get().then((value) {
          value.docs.forEach((element) {
            var pro = element.get('profession');
            var info = element.get('information');
            if (pro == 'teacher') {
              print(info);
            } else {
              print(info['batch']);
            }
          });
        });
      }),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * .05),
          child: width > 800

              //web
              ? Row(
                  children: [
                    //
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //
                          Text(
                            'Welcome to Campus Assistant',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Few steps to go...',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                          const SizedBox(height: 32),

                          //log in
                          ElevatedButton(
                              onPressed: () {
                                //
                                Get.to(const LoginScreen());
                              },
                              child: const Text('Log in')),

                          const SizedBox(height: 16),

                          // sign up
                          OutlinedButton(
                              onPressed: () {
                                Get.to(const Verification());
                              },
                              child: const Text('Sign up')),
                        ],
                      ),
                    ),
                  ],
                )

              //mobile
              : SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * .94,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //
                            Padding(
                              padding: EdgeInsets.only(top: height * .1),
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: width * .25,
                                width: width * .25,
                              ),
                            ),

                            //
                            Text(
                              'Welcome to \nCampus Assistant',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        //
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //log in
                            const Text(
                              'Already have an account?',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            // login dialog
                            ElevatedButton(
                                onPressed: () {
                                  Get.to(() => const LoginScreen());
                                  // showLoginDialog(context);
                                  //
                                },
                                child: const Text('Log in')),

                            const SizedBox(height: 20),

                            // sign up
                            const Text(
                              'New to this app?',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            //
                            OutlinedButton(
                                onPressed: () {
                                  Get.to(const Verification());
                                },
                                child: const Text('Create new account')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

//dialog
showLoginDialog(context) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(
        'LOGIN',
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.only(bottom: 16),
      actionsPadding: const EdgeInsets.all(10),
      content: const Text(
        "Choose your role to login!",
        textAlign: TextAlign.center,
      ),
      actions: [
        //
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: () {
                  //
                  Get.offNamed(LoginScreen.routeName, arguments: 'teacher');
                },
                child: const Text('Teacher')),

            const SizedBox(height: 12),

            //
            OutlinedButton(
                onPressed: () {
                  Get.offNamed(LoginScreen.routeName, arguments: 'student');
                },
                child: const Text('Student')),

            const SizedBox(height: 6),
          ],
        ),
      ],
    ),
  );
}
