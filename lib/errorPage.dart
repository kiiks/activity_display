import 'package:activity_display/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ErrorPage extends StatefulWidget {
  ErrorPage({Key? key}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  late VideoPlayerController _videoController;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/videos/erreur_palm.mp4')
          ..initialize().then((_) => {
                _videoController.addListener(checkIfVideoEnded),
                _videoController.setVolume(
                    0), // Due to bug on web, we need to set volume to 0 before playing
                setState(() {}),
              });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  playLocal() async {
    int result = await _audioPlayer.play("../assets/audio/error_sound.mp3",
        isLocal: true);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (value) {
        // Launch error video when "Space" is pressed
        if (value.isKeyPressed(LogicalKeyboardKey.space) ||
            value.isKeyPressed(LogicalKeyboardKey.enter)) {
          playLocal();
          _videoController.play();
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _videoController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController))
              : Container(),
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
