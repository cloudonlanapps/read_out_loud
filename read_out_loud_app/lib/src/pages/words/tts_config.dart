// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'tts_speaker.dart';

class TTSConfig extends StatefulWidget {
  final Size size;
  const TTSConfig({super.key, required this.size});

  @override
  TTSConfigState createState() => TTSConfigState();
}

class TTSConfigState extends State<TTSConfig> {
  late TTSSpeaker speaker;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  @override
  initState() {
    super.initState();
    speaker = TTSSpeaker();
    speaker.init(isAndroid: isAndroid);
  }

  @override
  void dispose() {
    super.dispose();
    speaker.flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Colors.green, Colors.greenAccent, Icons.play_arrow,
              'PLAY', () => speaker.speak("Can you read this word?")),
          _buildButtonColumn(
              Colors.red, Colors.redAccent, Icons.stop, 'STOP', speaker.stop),
          _buildButtonColumn(Colors.blue, Colors.blueAccent, Icons.pause,
              'PAUSE', speaker.pause),
        ],
      ),
    );
  }

  Widget _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return InkWell(
      onTap: () => func(),
      child: Container(
        decoration: const BoxDecoration(color: Colors.amber),
        width: 65,
        height: 65,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: color)))
            ]),
      ),
    );
  }
}
