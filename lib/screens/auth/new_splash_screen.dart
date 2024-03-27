import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/widgets/app_logo.dart';
import 'new_home_screen.dart';
import 'new_login_screen.dart';

class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({super.key});

  @override
  State<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  //
  @override
  void initState() {
    super.initState();

    // Create the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create the animation
    _animation = Tween<double>(begin: .9, end: 1).animate(_controller);

    // Add a listener to the animation to repeat the animation in a loop
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    // Start the animation
    _controller.forward();

    //

    Future.delayed(const Duration(milliseconds: 3000)).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WrapperScreen()),
          (route) => false);
    });
  }

  @override
  void dispose() {
    // Dispose the animation controller when the widget is removed from the tree
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: const AppLogo(),
          //todo: change logo
        ),
      ),
    );
  }
}

//
class WrapperScreen extends StatelessWidget {
  const WrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const NewHomeScreen();
        } else {
          return const NewLoginScreen();
        }
      },
    );
  }
}
