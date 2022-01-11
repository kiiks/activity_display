import 'dart:math';

import 'package:flutter/material.dart';

class CustomProgressBar extends StatefulWidget {
  final int currentPressure;
  const CustomProgressBar({Key? key, required this.currentPressure})
      : super(key: key);

  @override
  _CustomProgressBarState createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar> {
  final int maxPressure = 100;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: -1,
      child: CustomPaint(
        foregroundPainter: ProgressBarPainter(),
        child: SizedBox(
          width: 250, // inversed height
          height: 35, // inversed width
          child: LinearProgressIndicator(
            value: widget.currentPressure / maxPressure,
            color: Colors.red,
            minHeight: 10,
            backgroundColor: const Color(0xFF8E0E0E),
          ),
        ),
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height;
    double sw = size.width;

    double unit = size.width / 5; // width because box is reversed

    double topLeftCornerX = 0;
    double topLeftCornerY = 0;

    double topRightCornerX = sw;
    double topRightCornerY = 0;

    double bottomRightCornerX = sw;
    double bottomRightCornerY = sh;

    double bottomLeftCornerX = 0;
    double bottomLeftCornerY = sh;

    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    Path path = Path()
      ..moveTo(topLeftCornerX, topLeftCornerY)
      ..lineTo(bottomLeftCornerX, bottomLeftCornerY)
      ..moveTo(bottomLeftCornerX, bottomLeftCornerY)
      ..lineTo(bottomRightCornerX, bottomRightCornerY)
      ..moveTo(bottomLeftCornerX + (unit * 1),
          bottomLeftCornerY) // starting to make unit lines
      ..lineTo(bottomLeftCornerX + (unit * 1), topLeftCornerY)
      ..moveTo(bottomLeftCornerX + (unit * 2), bottomLeftCornerY)
      ..lineTo(bottomLeftCornerX + (unit * 2), topLeftCornerY)
      ..moveTo(bottomLeftCornerX + (unit * 3), bottomLeftCornerY)
      ..lineTo(bottomLeftCornerX + (unit * 3), topLeftCornerY)
      ..moveTo(bottomLeftCornerX + (unit * 4), bottomLeftCornerY)
      ..lineTo(bottomLeftCornerX + (unit * 4), topLeftCornerY)
      ..moveTo(bottomLeftCornerX + (unit * 5), bottomLeftCornerY)
      ..lineTo(bottomLeftCornerX + (unit * 5), topLeftCornerY)
      ..moveTo(bottomRightCornerX, bottomRightCornerY)
      ..lineTo(topRightCornerX, topRightCornerY)
      ..moveTo(topRightCornerX, topRightCornerY)
      ..lineTo(topLeftCornerX, topLeftCornerY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ProgressBarPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ProgressBarPainter oldDelegate) => false;
}
