import 'package:flutter/material.dart';

class LightIndicatorPainter extends CustomPainter {
  LightIndicatorPainter({required int nbLightsEnabled}) {
    lightEnabled = nbLightsEnabled;
  }

  int lightEnabled = 0;

  double offset = 30;

  final firstSuccessBackgroundColor = const Color(0x1B3A6FCC);
  final firstErrorBackgroundColor = const Color(0x1B8E0E0E); // 10% -> 1B

  final secondSuccessBackgroundColor = const Color(0x1B3A6FCC);
  final secondErrorBackgroundColor = const Color(0x4D8E0E0E); // 30% -> 4D

  final forgroundSuccessColor = const Color(0xFF3A6FCC);
  final forgroundErrorColor = const Color(0xFF8E0E0E); // 30% -> 4D

  final lineSuccessColor = const Color(0xFF3A6FCC);
  final lineErrorColor = const Color(0xFF8E0E0E); // 30% -> 4D

  bool get firstLightEnabled {
    return lightEnabled >= 1;
  }

  bool get secondLightEnabled {
    return lightEnabled >= 2;
  }

  bool get allLightEnabled {
    return lightEnabled >= 3;
  }

  void enableIndicator() {
    if (lightEnabled == 3) return;
    lightEnabled++;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height;
    double sw = size.width;

    Offset top = Offset(sw / 2, offset);
    Offset center = Offset(sw / 2, sh / 2);
    Offset bottom = Offset(sw / 2, sh - offset);

    Paint linePaint = Paint()
      ..color = lineErrorColor
      ..strokeWidth = 3
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint lineEnabledPaint = Paint()
      ..color = lineSuccessColor
      ..strokeWidth = 3
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint firstBackgroundCirclePaint = Paint()
      ..color = firstErrorBackgroundColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint firstBackgroundCircleEnabledPaint = Paint()
      ..color = firstSuccessBackgroundColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint secondBackgroundCirclePaint = Paint()
      ..color = secondErrorBackgroundColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint secondBackgroundCircleEnabledPaint = Paint()
      ..color = secondSuccessBackgroundColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint foregroundCirclePaint = Paint()
      ..color = forgroundErrorColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    Paint foregroundCircleEnabledPaint = Paint()
      ..color = forgroundSuccessColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(Offset(sw / 2, sh), bottom,
        firstLightEnabled ? lineEnabledPaint : linePaint);
    canvas.drawLine(
        bottom, center, secondLightEnabled ? lineEnabledPaint : linePaint);
    canvas.drawLine(
        center, top, allLightEnabled ? lineEnabledPaint : linePaint);

    // Bottom circle
    canvas.drawCircle(
        bottom,
        sw / 2,
        firstLightEnabled
            ? firstBackgroundCircleEnabledPaint
            : firstBackgroundCirclePaint);
    canvas.drawCircle(
        bottom,
        sw / 3,
        firstLightEnabled
            ? secondBackgroundCircleEnabledPaint
            : secondBackgroundCirclePaint);
    canvas.drawCircle(
        bottom,
        (sw / 2) / 3,
        firstLightEnabled
            ? foregroundCircleEnabledPaint
            : foregroundCirclePaint);

    // Center circle
    canvas.drawCircle(
        center,
        sw / 2,
        secondLightEnabled
            ? firstBackgroundCircleEnabledPaint
            : firstBackgroundCirclePaint);
    canvas.drawCircle(
        center,
        sw / 3,
        secondLightEnabled
            ? secondBackgroundCircleEnabledPaint
            : secondBackgroundCirclePaint);
    canvas.drawCircle(
        center,
        (sw / 2) / 3,
        secondLightEnabled
            ? foregroundCircleEnabledPaint
            : foregroundCirclePaint);

    // Top circle
    canvas.drawCircle(
        top,
        sw / 2,
        allLightEnabled
            ? firstBackgroundCircleEnabledPaint
            : firstBackgroundCirclePaint);
    canvas.drawCircle(
        top,
        sw / 3,
        allLightEnabled
            ? secondBackgroundCircleEnabledPaint
            : secondBackgroundCirclePaint);
    canvas.drawCircle(top, (sw / 2) / 3,
        allLightEnabled ? foregroundCircleEnabledPaint : foregroundCirclePaint);
  }

  @override
  bool shouldRepaint(LightIndicatorPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LightIndicatorPainter oldDelegate) => false;
}
