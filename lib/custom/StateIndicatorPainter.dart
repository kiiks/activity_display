import 'package:flutter/material.dart';

class StateIndicatorPainter extends CustomPainter {
  StateIndicatorPainter({required bool enabled}) {
    success = enabled;
  }

  bool success = false;

  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height;
    double sw = size.width;

    final bacgroundColor =
        success ? const Color(0x4D3A6FCC) : const Color(0x4D8E0E0E);
    final foregroundColor =
        success ? const Color(0xFF3A6FCC) : const Color(0xFF8E0E0E);

    Paint backgroundCirclePaint = Paint()
      ..color = bacgroundColor // 30% -> 4D
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint foregroundCirclePaint = Paint()
      ..color = foregroundColor
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
  BigStateIndicatorPainter({required bool enabled}) {
    success = enabled;
  }

  bool success = false;

  void enableIndicator() {
    success = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height;
    double sw = size.width;

    final backgroundColor = success
        ? const Color(0x4D3A6FCC)
        : const Color(0x4D8E0E0E); // 30% -> 4D

    final forgroundColor =
        success ? const Color(0xFF3A6FCC) : const Color(0xFF8E0E0E);

    Paint backgroundCirclePaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint foregroundCirclePaint = Paint()
      ..color = forgroundColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint backgroundCircleBorder = Paint()
      ..color = forgroundColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    canvas.drawCircle(Offset(sw / 2, sh / 2), sw / 2, backgroundCirclePaint);
    canvas.drawCircle(Offset(sw / 2, sh / 2), sw / 2, backgroundCircleBorder);
    canvas.drawCircle(
        Offset(sw / 2, sh / 2), (sw / 2) / 1.40, foregroundCirclePaint);
  }

  @override
  bool shouldRepaint(BigStateIndicatorPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BigStateIndicatorPainter oldDelegate) => false;
}
