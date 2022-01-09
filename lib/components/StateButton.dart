import 'package:flutter/material.dart';

class StateButton extends StatefulWidget {
  const StateButton() : super();

  @override
  _StateButtonState createState() => _StateButtonState();
}

class _StateButtonState extends State<StateButton> {
  String _state = "OFF";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: const RadialGradient(
              radius: 1,
              focalRadius: 0,
              center: Alignment.center,
              colors: [Color(0xFF040423), Color(0xFFED1C24)]),
          border: Border.all(
            color: Colors.white,
          )),
      child: Text(
        _state,
        style: const TextStyle(
            color: Colors.white, fontFamily: 'Conthrax', fontSize: 20),
      ),
    );
  }
}
