import 'package:flutter/material.dart';

class Hole extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(20)),
      Paint()
        ..blendMode = BlendMode.xor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0),
    );
  }

  @override
  bool shouldRepaint(Hole oldDelegate) => false;
}
