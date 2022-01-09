import 'package:flutter/material.dart';

class CornerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage

    double margin = 10;
    double topLeftCornerX = margin;
    double topLeftCornerY = margin;

    double topRightCornerX = sw - margin;
    double topRightCornerY = margin;

    double bottomRightCornerX = sw - margin;
    double bottomRightCornerY = sh - margin;

    double bottomLeftCornerX = margin;
    double bottomLeftCornerY = sh - margin;

    double lineSize = 40;

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    Path path = Path()
      ..moveTo(topLeftCornerX, topLeftCornerY)
      ..lineTo(topLeftCornerX, topLeftCornerY + lineSize)
      ..moveTo(topLeftCornerX, topLeftCornerY)
      ..lineTo(topLeftCornerX + lineSize, topLeftCornerY)
      ..moveTo(topRightCornerX, topRightCornerY)
      ..lineTo(topRightCornerX - lineSize, topRightCornerY)
      ..moveTo(topRightCornerX, topRightCornerY)
      ..lineTo(topRightCornerX, topRightCornerY + lineSize)
      ..moveTo(bottomRightCornerX, bottomRightCornerY)
      ..lineTo(bottomRightCornerX, bottomRightCornerY - lineSize)
      ..moveTo(bottomRightCornerX, bottomRightCornerY)
      ..lineTo(bottomRightCornerX - lineSize, bottomRightCornerY)
      ..moveTo(bottomLeftCornerX, bottomLeftCornerY)
      ..lineTo(bottomLeftCornerX, bottomLeftCornerY - lineSize)
      ..moveTo(bottomLeftCornerX, bottomLeftCornerY)
      ..lineTo(bottomLeftCornerX + lineSize, bottomLeftCornerY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CornerBorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CornerBorderPainter oldDelegate) => false;
}
