// ignore_for_file: deprecated_member_use
// @dart=2.9

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(const Duration(seconds: 3),
          ColorTween(begin: const Color.fromARGB(255, 29, 105, 167), end: const Color.fromARGB(255, 0, 120, 211))),
      Track("color2").add(const Duration(seconds: 3),
          ColorTween(begin: const Color.fromARGB(255, 7, 47, 95), end: const Color.fromARGB(255, 58, 149, 230)))
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(90),
              bottomRight: Radius.circular(90)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [animation["color1"], animation["color2"]])),
        );
      },
    );
  }
}