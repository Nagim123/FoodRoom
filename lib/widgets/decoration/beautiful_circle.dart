import 'dart:ui';

import 'package:flutter/material.dart';

class BeautifulCircle extends StatelessWidget {
  const BeautifulCircle(
      {super.key, required this.circleRadius, required this.mainColor});

  final double circleRadius;
  final Color mainColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleRadius,
      height: circleRadius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [mainColor, Colors.transparent],
          stops: const [0.2, 1.0],
          center: Alignment.center,
          radius: 0.5,
        ),
      ),
    );
  }
}
