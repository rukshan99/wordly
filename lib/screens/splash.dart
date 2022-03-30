import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:wordly/screens/welcome.dart';
import 'package:wordly/utils/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AnimatedSplashScreen(
          duration: 4000,
          splash: 'assets/img/logo.jpg',
          splashIconSize: 160,
          nextScreen: const WelcomeScreen(),
          splashTransition: SplashTransition.sizeTransition,
          pageTransitionType: PageTransitionType.bottomToTop,
          backgroundColor: purpleColors,
        )
    );
  }
}
