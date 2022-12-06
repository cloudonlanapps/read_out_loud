// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tts/tts_speaker.dart';

class TTSConfig extends ConsumerWidget {
  final Size size;
  const TTSConfig({super.key, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(ttsSpeakerProvider);
    return SizedBox.fromSize(
      size: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(
              Colors.green,
              Colors.greenAccent,
              Icons.play_arrow,
              'PLAY',
              () => ref
                  .read(ttsSpeakerProvider.notifier)
                  .play("Can you read this word?")),
          _buildButtonColumn(Colors.red, Colors.redAccent, Icons.stop, 'STOP',
              ref.read(ttsSpeakerProvider.notifier).stop),
          /* _buildButtonColumn(Colors.blue, Colors.blueAccent, Icons.pause,
              'PAUSE', ref.read(ttsSpeakerProvider.notifier).pause), */
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
