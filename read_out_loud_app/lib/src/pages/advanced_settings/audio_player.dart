import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';
import '../../tts/tts_speaker.dart';
import 'audio_parameters.dart';

class AudioPlayerConfig extends ConsumerStatefulWidget {
  const AudioPlayerConfig({super.key});

  @override
  AudioPlayerConfigState createState() => AudioPlayerConfigState();
}

enum TtsState {
  playing,
  stopped,
}

class AudioPlayerConfigState extends ConsumerState<AudioPlayerConfig> {
  final textStyle = const TextStyle(color: Colors.blueGrey, fontSize: 20);
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TTSSpeaker ttsSpeaker = ref.watch(ttsSpeakerProvider);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 24, bottom: 8, left: 8, right: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), border: Border.all()),
          padding: const EdgeInsets.all(8),
          child: Text(
            ttsSpeaker.sampleText,
            style: textStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 8),
          child: CustomMenu(menuItems: [
            null,
            CustomMenuItem(
                alignment: Alignment.bottomCenter,
                icon: Icons.play_arrow,
                color: Colors.greenAccent,
                onTap: () async {
                  await ref.read(ttsSpeakerProvider.notifier).play(
                      ttsSpeaker.sampleText,
                      onComplete: () {},
                      onCancel: () {});
                },
                title: 'Play'),
            CustomMenuItem(
                alignment: Alignment.bottomCenter,
                icon: Icons.stop,
                color: Colors.redAccent,
                onTap: () async {
                  await ref.read(ttsSpeakerProvider.notifier).stop();
                },
                title: 'Stop'),
            null,
          ]),
        ),
        if (ttsSpeaker.isStopped)
          const Padding(
            padding: EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 8),
            child: AudioParameters(),
          ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
