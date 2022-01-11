import 'package:activity_display/main.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ErrorPage extends StatefulWidget {
  ErrorPage({Key? key}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    _videoController =
        VideoPlayerController.asset('assets/videos/erreur_palm.mp4');
    _videoController
        .initialize()
        .then((value) => {_videoController.play(), setState(() {})});
    _videoController.addListener(checkIfVideoEnded);

    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        ),
      ),
    );
  }

  void checkIfVideoEnded() {
    if (!_videoController.value.isInitialized) return;

    if (_videoController.value.position == _videoController.value.duration) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    }
  }
}
