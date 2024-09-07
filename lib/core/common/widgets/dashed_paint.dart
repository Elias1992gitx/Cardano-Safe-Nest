import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius borderRadius;

  const DashedBorderContainer({
    required this.child,
    required this.borderColor,
    this.borderWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.borderRadius = BorderRadius.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: borderColor,
        borderWidth: borderWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.borderWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(borderRadius.toRRect(Rect.fromLTWH(0, 0, size.width, size.height)));

    final dashPath = Path();
    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}