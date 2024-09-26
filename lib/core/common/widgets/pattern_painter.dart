import 'package:flutter/material.dart';

class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    const double step = 20.0;

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        path.addOval(Rect.fromCircle(center: Offset(x, y), radius: 5));
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}