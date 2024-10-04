import 'package:flutter/material.dart';
import 'dart:math' as math;

class PatternPainter extends CustomPainter {
  final Color color;
  final double opacity;

  PatternPainter({
    this.color = Colors.grey,
    this.opacity = 0.1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final double elementSize = 40;
    final double spacing = 60;

    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        _drawElement(canvas, Offset(x, y), elementSize, paint);
      }
    }
  }

  void _drawElement(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    
    // Draw a circle
    path.addOval(Rect.fromCircle(center: center, radius: size / 4));

    // Draw a square
    path.addRect(Rect.fromCenter(center: center, width: size / 2, height: size / 2));

    // Draw a triangle
    final trianglePath = Path();
    final triangleHeight = size / 2 * math.sqrt(3) / 2;
    trianglePath.moveTo(center.dx, center.dy - triangleHeight / 2);
    trianglePath.lineTo(center.dx - size / 4, center.dy + triangleHeight / 2);
    trianglePath.lineTo(center.dx + size / 4, center.dy + triangleHeight / 2);
    trianglePath.close();
    path.addPath(trianglePath, Offset.zero);

    // Draw the combined shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}