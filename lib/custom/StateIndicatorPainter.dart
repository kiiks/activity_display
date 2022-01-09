import 'package:flutter/material.dart';

class StateIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage

    Paint backgroundCirclePaint = Paint()
      ..color = const Color(0x4D8E0E0E) // 30% -> 4D
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint foregroundCirclePaint = Paint()
      ..color = const Color(0xFF8E0E0E)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    canvas.drawCircle(Offset(sw / 2, sh / 2), sw / 2, backgroundCirclePaint);
    canvas.drawCircle(
        Offset(sw / 2, sh / 2), (sw / 2) / 2, foregroundCirclePaint);
  }

  @override
  bool shouldRepaint(StateIndicatorPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(StateIndicatorPainter oldDelegate) => false;
}

class BigStateIndicatorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage

    Paint backgroundCirclePaint = Paint()
      ..color = const Color(0x4D8E0E0E) // 30% -> 4D
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint foregroundCirclePaint = Paint()
      ..color = const Color(0xFF8E0E0E)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint backgroundCircleBorder = Paint()
      ..color = const Color(0xFF8E0E0E)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    canvas.drawCircle(Offset(sw / 2, sh / 2), sw / 2, backgroundCirclePaint);
    canvas.drawCircle(Offset(sw / 2, sh / 2), sw / 2, backgroundCircleBorder);
    canvas.drawCircle(
        Offset(sw / 2, sh / 2), (sw / 2) / 1.50, foregroundCirclePaint);
  }

  @override
  bool shouldRepaint(StateIndicatorPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(StateIndicatorPainter oldDelegate) => false;
}
