import 'package:flutter/material.dart';

import 'package:activity_display/services/types.dart';
import 'package:activity_display/services/ws.dart';

import 'package:activity_display/custom/CornerBorderPainter.dart';
import 'package:activity_display/custom/StateIndicatorPainter.dart';
import 'package:activity_display/components/StateButton.dart';
import 'package:activity_display/components/ProgressBar.dart';
import 'package:activity_display/components/LightIndicator.dart';

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

  bool mazeDone = false;
  bool pumpDone = false;
  bool desertDone = false;

  // UI variables

  final double margin = 10;
  final double boxWidth = 650;

  // Video player variables

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
    _mazeVideoController.dispose();
    _desertVideoController.dispose();
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
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: AspectRatio(
                              aspectRatio: 1.36,
                              child: VideoPlayer(_mazeVideoController)),
                        ),
                        Container(
                            margin: EdgeInsets.all(margin),
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
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 20, 0),
                                        child: const Text(
                                          'ÉTAT',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Advent Pro'),
                                        ),
                                      ),
                                      StateButton(enabled: mazeDone)
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 15, 0),
                                        child: CustomPaint(
                                            foregroundPainter:
                                                StateIndicatorPainter(
                                                    enabled: mazeDone),
                                            child: const SizedBox(
                                              width: 25,
                                              height: 25,
                                            )),
                                      ),
                                      mazeDone
                                          ? const Text(
                                              'SYSTÈME AUTONOMNE',
                                              style: TextStyle(
                                                  color: Color(0xFF3A6FCC),
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Conthrax'),
                                            )
                                          : const Text(
                                              'BESOIN INTERVENTION',
                                              style: TextStyle(
                                                  color: Color(0xFFED1C24),
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Conthrax'),
                                            ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: !mazeDone,
                                  child: const Text(
                                      'Panne système - Automatisation du système impossible',
                                      style: TextStyle(
                                          color: Color(0xFFED1C24),
                                          fontFamily: 'Advent Pro',
                                          fontSize: 26)),
                                )
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.all(margin),
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
                                            BigStateIndicatorPainter(
                                                enabled:
                                                    nbMazeLEDsEnbaled >= 1),
                                        child: const SizedBox(
                                          width: 75,
                                          height: 75,
                                        )),
                                    CustomPaint(
                                        foregroundPainter:
                                            BigStateIndicatorPainter(
                                                enabled:
                                                    nbMazeLEDsEnbaled >= 2),
                                        child: const SizedBox(
                                          width: 75,
                                          height: 75,
                                        )),
                                    CustomPaint(
                                        foregroundPainter:
                                            BigStateIndicatorPainter(
                                                enabled:
                                                    nbMazeLEDsEnbaled >= 3),
                                        child: const SizedBox(
                                          width: 75,
                                          height: 75,
                                        )),
                                    Text(
                                      nbMazeLEDsEnbaled.toString() + "/3",
                                      style: const TextStyle(
                                          color: Color(0xFFED1C24),
                                          fontFamily: 'Conthrax',
                                          fontSize: 32),
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
                                    children: [
                                      const Text(
                                        'ÉTAT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Advent Pro'),
                                      ),
                                      StateButton(enabled: pumpDone)
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
                                              StateIndicatorPainter(
                                                  enabled: pumpDone),
                                          child: const SizedBox(
                                            width: 25,
                                            height: 25,
                                          )),
                                      pumpDone
                                          ? const Text(
                                              'SYSTÈME AUTONOMNE',
                                              style: TextStyle(
                                                  color: Color(0xFF3A6FCC),
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Conthrax'),
                                            )
                                          : const Text(
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
                                CustomProgressBar(
                                    currentPressure: currentPressure),
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                                .round()
                                                .toString() +
                                            '%',
                                        style: const TextStyle(
                                            color: Color(0xFFED1C24),
                                            fontFamily: 'Conthrax',
                                            fontSize: 34,
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
                        Container(
                          margin: const EdgeInsets.all(15),
                          child: AspectRatio(
                              aspectRatio: 1.36,
                              child: VideoPlayer(_desertVideoController)),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      const Text('Alimentation électrique',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26,
                                              fontFamily: 'Conthrax'),
                                          textAlign: TextAlign.center),
                                      const Text(
                                        'Apport en lumière',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontFamily: 'Advent Pro'),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 25, 0, 15),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 20, 0),
                                              child: const Text(
                                                'ÉTAT',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Advent Pro'),
                                              ),
                                            ),
                                            StateButton(
                                              enabled: desertDone,
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: CustomPaint(
                                                foregroundPainter:
                                                    StateIndicatorPainter(
                                                        enabled: desertDone),
                                                child: const SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                )),
                                          ),
                                          desertDone
                                              ? const Text(
                                                  'SYSTÈME AUTONOMNE',
                                                  style: TextStyle(
                                                      color: Color(0xFF3A6FCC),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Conthrax'),
                                                )
                                              : const Text(
                                                  'BESOIN INTERVENTION',
                                                  style: TextStyle(
                                                      color: Color(0xFFED1C24),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Conthrax'),
                                                ),
                                        ],
                                      ),
                                      Visibility(
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        visible: !desertDone,
                                        child: const Text(
                                            'Câblage défectueux - Intervention requise',
                                            style: TextStyle(
                                                color: Color(0xFFED1C24),
                                                fontFamily: 'Advent Pro',
                                                fontSize: 26)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)),
                                child: Column(
                                  children: [
                                    const Text('PILLIERS ÉLECTRIQUES ALIMENTÉS',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Advent Pro',
                                            fontSize: 26),
                                        textAlign: TextAlign.center),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        LightIndicator(
                                          lightsEnabled: nbDesertLEDsEnbaled,
                                        ),
                                        Text(
                                            nbDesertLEDsEnbaled.toString() +
                                                "/3",
                                            style: const TextStyle(
                                                color: Color(0xFFED1C24),
                                                fontFamily: 'Conthrax',
                                                fontSize: 32))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        FloatingActionButton(
                          onPressed: onDesert,
                          child: const Text('DESERT'),
                        ),
                        FloatingActionButton(
                          onPressed: onPompe,
                          child: const Text('POMPE'),
                        ),
                        FloatingActionButton(
                          onPressed: onMaze,
                          child: const Text('MAZE'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void onDesert() {
    desertDone = true;
    setState(() {});
  }

  void onPompe() {
    pumpDone = true;
    setState(() {});
  }

  void onMaze() {
    mazeDone = true;
    setState(() {});
  }

  void didRecieveFromESP(String data) {
    var request = data.split("@");
    var activity = request[0];
    var command = request[1].split(":");
    var commandType = command[0];
    var commandData = command[1];

    // TODO: SALADE Management

    switch (activity) {
      case Activity.LABYRINTHE:
        if (commandType == CommandType.INFO) {
          if (nbMazeLEDsEnbaled == 3) return;
          nbMazeLEDsEnbaled = int.parse(commandData);
        }
        break;
      case Activity.DESERT:
        if (commandType == CommandType.INFO) {
          if (nbDesertLEDsEnbaled == 3) return;
          nbDesertLEDsEnbaled = int.parse(commandData);
        }
        break;
      case Activity.POMPE:
        if (commandType == CommandType.INFO) {
          final newValue = int.parse(commandData);
          if (newValue >= maxPressure) {
            currentPressure = 150;
            return;
          }
          ;
          currentPressure = newValue;
        }
        break;
      default:
    }
    setState(() {});
  }

  void initVideoControllers() {
    _pumpVideoController =
        VideoPlayerController.asset('assets/videos/animation_pompe.mp4');
    _pumpVideoController.initialize().then((value) => {
          _pumpVideoController.setLooping(true),
          _pumpVideoController.play(),
          setState(() {})
        });

    _mazeVideoController =
        VideoPlayerController.asset('assets/videos/animation_tuyaux.mp4');
    _mazeVideoController.initialize().then((value) => {
          _mazeVideoController.setLooping(true),
          _mazeVideoController.play(),
          setState(() {})
        });

    _desertVideoController =
        VideoPlayerController.asset('assets/videos/animation_desert.mp4');
    _desertVideoController.initialize().then((value) => {
          _desertVideoController.setLooping(true),
          _desertVideoController.play(),
          setState(() {})
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
