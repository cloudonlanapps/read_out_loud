import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'audio_player.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final String? filename;
  const MainContent({super.key, required this.filename, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
            child: const ExpansionTile(
              initiallyExpanded: true,
              title: TitleText("AudioPlayer Settings"),
              children: [AudioPlayerConfig()],
            )),
        Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
            child: const ExpansionTile(
              initiallyExpanded: true,
              title: TitleText("AudioPlayer Settings"),
              children: [AudioPlayerConfig()],
            ))
      ],
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  const TitleText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
      textAlign: TextAlign.start,
    );
  }
}

class SubtitleText extends StatelessWidget {
  final String text;
  const SubtitleText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.blueGrey, fontSize: 20),
      textAlign: TextAlign.start,
    );
  }
}
