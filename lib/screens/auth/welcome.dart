import 'package:flutter/material.dart';

import '/screens/auth/signup1.dart';
import 'login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  //
  static const routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(width * .05),
          child: width > 800
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                Navigator.pushNamed(
                                    context, LoginScreen.routeName);
                              },
                              child: const Text('Log in')),

                          const SizedBox(height: 16),

                          // sign up
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, SignUpScreen1.routeName);

                                //
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => const SignUpScreen1()));
                              },
                              child: const Text('Sign up')),
                        ],
                      ),
                    ),
                  ],
                )

              //mobile
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          Padding(
                            padding: EdgeInsets.only(top: height * .1),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: width * .3,
                              width: width * .3,
                            ),
                          ),

                          //
                          Text(
                            'Welcome to \nCampus Assistant',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    //
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //log in
                          const Text(
                            'Already have an account?',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          //
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  LoginScreen.routeName,
                                  arguments: 'Student',
                                );

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
                                Navigator.pushNamed(
                                    context, SignUpScreen1.routeName);

                                //
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => const SignUpScreen1()));
                              },
                              child: const Text('Create new account')),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

showDialog(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
            // height: 200,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                Text(
                  'Login as',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                //
                Container(
                  height: 5,
                  width: 100,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  // color: Theme.of(context).dividerColor,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                //
                Card(
                  elevation: 2,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        LoginScreen.routeName,
                        arguments: 'Student',
                      );
                    },
                    title: const Text('Student'),
                  ),
                ),

                //
                Card(
                  elevation: 2,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        LoginScreen.routeName,
                        arguments: 'Teacher',
                      );
                    },
                    title: const Text('Teacher'),
                  ),
                ),
              ],
            ),
          ));
}
