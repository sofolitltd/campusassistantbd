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
                ),
        ),
      ),
    );
  }
}
