import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wordly/utils/animated_background.dart';
import 'package:wordly/utils/animated_wave.dart';
import 'package:wordly/utils/color.dart';

// ignore: must_be_immutable
class HeaderContainer extends StatelessWidget {
  var text = "Login";

  HeaderContainer(this.text, {Key? key}) : super(key: key);

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.38,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const Positioned(child: AnimatedBackground()),
          onBottom(const AnimatedWave(
            height: 120,
            speed: 1.0,
          )),
          onBottom(const AnimatedWave(
            height: 60,
            speed: 0.9,
            offset: pi,
          )),
          onBottom(const AnimatedWave(
            height: 160,
            speed: 1.2,
            offset: pi / 2,
          )),
          Positioned(
              bottom: 15,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )),
          Center(
            child: Image.asset("assets/img/logo.jpg"),
          ),
        ],
      ),
    );
  }
}
