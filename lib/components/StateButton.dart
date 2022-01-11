import 'package:flutter/material.dart';

class StateButton extends StatefulWidget {
  final bool enabled;

  const StateButton({Key? key, required this.enabled}) : super(key: key);

  @override
  _StateButtonState createState() => _StateButtonState();
}

class _StateButtonState extends State<StateButton> {
  Color backgroundColor = const Color(0xFF040423);
  Color successColor = const Color(0xFF3A6FCC);
  Color errorColor = const Color(0xFFED1C24);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: RadialGradient(
              radius: 1,
              focalRadius: 0,
              center: Alignment.center,
              colors: [
                backgroundColor,
                widget.enabled ? successColor : errorColor
              ]),
          border: Border.all(
            color: Colors.white,
          )),
      child: Text(
        widget.enabled ? "ON" : "OFF",
        style: const TextStyle(
            color: Colors.white, fontFamily: 'Conthrax', fontSize: 20),
      ),
    );
  }
}
