import 'package:activity_display/types.dart';
import 'package:activity_display/ws.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PALM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(title: 'PALM Interface'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WebSocketManager wsManager = WebSocketManager();

  final maxPressure = 150;

  int nbDesertLEDsEnbaled = 0;
  int nbMazeLEDsEnbaled = 0;
  int currentPressure = 0;

  @override
  void initState() {
    super.initState();
    wsManager.listen(didRecieve: didRecieveFromESP);
  }

  void didRecieveFromESP(String data) {
    print(data);
    var request = data.split("@");
    var activity = request[0];
    var command = request[1].split(":");
    var commandType = command[0];
    var commandData = command[1];

    switch (activity) {
      case Activity.LABYRINTHE:
        if (commandType == CommandType.INFO) {
          nbMazeLEDsEnbaled = int.parse(commandData);
        }
        break;
      case Activity.DESERT:
        if (commandType == CommandType.INFO) {
          nbDesertLEDsEnbaled = int.parse(commandData);
        }
        break;
      case Activity.POMPE:
        if (commandType == CommandType.INFO) {
          currentPressure = int.parse(commandData);
        }
        break;
      default:
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 150),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              border: Border.all(color: Colors.blueGrey),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: SizedBox(
              width: 600,
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nombre de biomasse récolté :"),
                      Text(nbMazeLEDsEnbaled.toString() + "/3")
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Pression :"),
                      SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          value: currentPressure / maxPressure,
                          color: Colors.blue,
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nombre de poteaux réparés :"),
                      Text(nbDesertLEDsEnbaled.toString() + "/3")
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
