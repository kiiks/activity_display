import 'package:flutter/material.dart';

import 'package:activity_display/types.dart';
import 'package:activity_display/ws.dart';

import 'package:activity_display/custom/CornerBorderPainter.dart';
import 'package:activity_display/custom/StateIndicatorPainter.dart';
import 'package:activity_display/components/StateButton.dart';
import 'package:activity_display/components/ProgressBar.dart';

import 'package:video_player/video_player.dart';

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

  // Activity variables

  final maxPressure = 150;

  int nbDesertLEDsEnbaled = 0;
  int nbMazeLEDsEnbaled = 0;
  int currentPressure = 0;

  // UI variables

  final double margin = 10;
  final double boxWidth = 600;

  // Vide player variables

  late VideoPlayerController _pumpVideoController;
  late VideoPlayerController _mazeVideoController;
  late VideoPlayerController _desertVideoController;

  @override
  void initState() {
    super.initState();
    wsManager.listen(didRecieve: didRecieveFromESP);

    initVideoControllers();
  }

  @override
  void dispose() {
    _pumpVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF040423),
        body: Center(
          child: IntrinsicWidth(
            child: Row(
              children: [
                CustomPaint(
                  foregroundPainter: CornerBorderPainter(),
                  child: Container(
                    height: double.infinity,
                    width: boxWidth,
                    margin: EdgeInsets.all(margin),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(26, 255, 255, 255)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                            aspectRatio: _mazeVideoController.value.aspectRatio,
                            child: VideoPlayer(_mazeVideoController)),
                        Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            child: Column(
                              children: [
                                const Text(
                                  'Acheminement des eaux grises',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontFamily: 'Conthrax'),
                                ),
                                const Text(
                                  'Récupération des minéraux nécéssaires',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontFamily: 'Advent Pro'),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            'ÉTAT',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Advent Pro'),
                                          ),
                                          // TODO: Add state management
                                          StateButton()
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CustomPaint(
                                              foregroundPainter:
                                                  // TODO : Color state management
                                                  StateIndicatorPainter(),
                                              child: const SizedBox(
                                                width: 25,
                                                height: 25,
                                              )),
                                          const Text(
                                            'BESOIN INTERVENTION',
                                            style: TextStyle(
                                                color: Color(0xFFED1C24),
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Conthrax'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Text(
                                    'Panne système - Automatisation du système impossible',
                                    style: TextStyle(
                                        color: Color(0xFFED1C24),
                                        fontFamily: 'Advent Pro',
                                        fontSize: 26))
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)),
                          child: Column(
                            children: [
                              const Text(
                                'VANNES À ACTIVER',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Advent Pro',
                                    fontSize: 26),
                              ),
                              Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomPaint(
                                        foregroundPainter:
                                            // TODO : Color state management
                                            StateIndicatorPainter(),
                                        child: const SizedBox(
                                          width: 75,
                                          height: 75,
                                        )),
                                    CustomPaint(
                                        foregroundPainter:
                                            // TODO : Color state management
                                            StateIndicatorPainter(),
                                        child: const SizedBox(
                                          width: 75,
                                          height: 75,
                                        )),
                                    CustomPaint(
                                        foregroundPainter:
                                            // TODO : Color state management
                                            StateIndicatorPainter(),
                                        child: const SizedBox(
                                          width: 75,
                                          height: 75,
                                        )),
                                    Text(
                                      nbMazeLEDsEnbaled.toString() + "/3",
                                      style: const TextStyle(
                                          color: Color(0xFFED1C24),
                                          fontFamily: 'Conthrax',
                                          fontSize: 25),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                CustomPaint(
                  foregroundPainter: CornerBorderPainter(),
                  child: Container(
                    width: 350,
                    margin: EdgeInsets.all(margin),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(26, 255, 255, 255)),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AspectRatio(
                              aspectRatio:
                                  _pumpVideoController.value.aspectRatio,
                              child: VideoPlayer(_pumpVideoController)),
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            child: Column(
                              children: [
                                const Text(
                                  'Filtrage de l\'air',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontFamily: 'Conthrax'),
                                ),
                                const Text(
                                  'Récuprération du CO2',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontFamily: 'Advent Pro'),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 25, 0, 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      Text(
                                        'ÉTAT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Advent Pro'),
                                      ),
                                      // TODO: Add state management
                                      StateButton()
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      CustomPaint(
                                          foregroundPainter:
                                              // TODO : Color state management
                                              StateIndicatorPainter(),
                                          child: const SizedBox(
                                            width: 25,
                                            height: 25,
                                          )),
                                      const Text(
                                        'BESOIN INTERVENTION',
                                        style: TextStyle(
                                            color: Color(0xFFED1C24),
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Conthrax'),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // TODO: Add pressure management
                                CustomProgressBar(),
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'PRESSION À ENVOYER',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Advent Pro',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        ((currentPressure / maxPressure) * 100)
                                                .toString() +
                                            '%',
                                        style: const TextStyle(
                                            color: Color(0xFFED1C24),
                                            fontFamily: 'Advent Pro',
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ])
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                CustomPaint(
                  foregroundPainter: CornerBorderPainter(),
                  child: Container(
                    height: double.infinity,
                    width: boxWidth,
                    margin: EdgeInsets.all(margin),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(26, 255, 255, 255)),
                    child: Column(
                      children: [
                        AspectRatio(
                            aspectRatio:
                                _desertVideoController.value.aspectRatio,
                            child: VideoPlayer(_desertVideoController)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void didRecieveFromESP(String data) {
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

  void initVideoControllers() {
    _pumpVideoController =
        VideoPlayerController.asset('assets/videos/animation_pompe.mp4');
    _pumpVideoController.initialize().then((value) =>
        {_pumpVideoController.setLooping(true), _pumpVideoController.play()});

    _mazeVideoController =
        VideoPlayerController.asset('assets/videos/animation_tuyaux.mp4');
    _mazeVideoController.initialize().then((value) =>
        {_mazeVideoController.setLooping(true), _mazeVideoController.play()});

    _desertVideoController =
        VideoPlayerController.asset('assets/videos/animation_desert.mp4');
    _desertVideoController.initialize().then((value) => {
          _desertVideoController.setLooping(true),
          _desertVideoController.play()
        });
  }
}

// Align(
//         alignment: Alignment.bottomCenter,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(0, 0, 0, 150),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.orange,
//               border: Border.all(color: Colors.blueGrey),
//               borderRadius: const BorderRadius.all(Radius.circular(30)),
//             ),
//             child: SizedBox(
//               width: 600,
//               height: 150,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Nombre de biomasse récolté :"),
//                       Text(nbMazeLEDsEnbaled.toString() + "/3")
//                     ],
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Pression :"),
//                       SizedBox(
//                         width: 100,
//                         child: LinearProgressIndicator(
//                           value: currentPressure / maxPressure,
//                           color: Colors.blue,
//                           minHeight: 10,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Nombre de poteaux réparés :"),
//                       Text(nbDesertLEDsEnbaled.toString() + "/3")
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
