import 'package:flutter/material.dart';

class DiagonalStripePainter extends CustomPainter {
  final double spacing;
  final double strokeWidth;
  final Color color;

  DiagonalStripePainter({
    this.spacing = 20,
    this.strokeWidth = 2,
    this.color = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
