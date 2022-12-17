import 'package:campusassistant/admin/attendance.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({Key? key}) : super(key: key);
  static const routeName = '/admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 64,
                      width: 64,
                    ),

                    const SizedBox(width: 8),
                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Text('Campus Assistant'),
                      ],
                    ),
                  ],
                ),
                // Text(
                //   'Admin',
                //   // style: Theme.of(context).textTheme.titleLarge,
                // ),
                const Divider(
                    // thickness: 2,
                    ),

                const SizedBox(height: 16),

                // email
                const Text('Email'),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Enter your email'),
                ),

                const SizedBox(height: 24),

                //pass
                const Text('Password'),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter password',
                  ),
                ),

                const SizedBox(height: 16),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text('Forgot password?')),
                  ],
                ),

                const SizedBox(height: 16),

                //
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          //
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Attendance()),
                              (route) => false);
                        },
                        child: const Text('Login')))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
