import 'package:activity_display/custom/LightIndicatorPainter.dart';
import 'package:flutter/material.dart';
import 'package:activity_display/components/LightIndicator.dart';

class LightIndicator extends StatefulWidget {
  final int lightsEnabled;
  const LightIndicator({Key? key, required this.lightsEnabled})
      : super(key: key);

  @override
  _LightIndicatorState createState() => _LightIndicatorState();
}

class _LightIndicatorState extends State<LightIndicator> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 100,
      child: CustomPaint(
        foregroundPainter:
            LightIndicatorPainter(nbLightsEnabled: widget.lightsEnabled),
      ),
    );
  }
}
