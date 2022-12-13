import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud_app/src/custom_widgets/custom_menu.dart';
import 'package:read_out_loud_app/src/custom_widgets/menu4.dart';

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
  late TextEditingController textEditingController;

  @override
  initState() {
    textEditingController =
        TextEditingController(text: ref.read(ttsSpeakerProvider).sampleText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TTSSpeaker ttsSpeaker = ref.watch(ttsSpeakerProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8, left: 8, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 2, color: Colors.blueGrey), //<-- SEE HERE
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              controller: textEditingController,
              style: Theme.of(context).textTheme.bodyMedium!,
              minLines: 2,
              maxLines: 2,
              textInputAction: TextInputAction.done),
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () async {
                    textEditingController.text = ttsSpeaker.sampleText;
                  },
                  child: const Text("Restore sample text"))),
          Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 8),
            child: Menu4(height: 65, children: [
              null,
              CustomMenuButton(
                menuItem: CustomMenuItem(
                    alignment: Alignment.bottomCenter,
                    icon: Icons.play_arrow,
                    color: Colors.greenAccent,
                    onTap: () async {
                      await ref.read(ttsSpeakerProvider.notifier).play(
                          textEditingController.text,
                          onComplete: () {},
                          onCancel: () {});
                    },
                    title: 'Play'),
              ),
              CustomMenuButton(
                menuItem: CustomMenuItem(
                    alignment: Alignment.bottomCenter,
                    icon: Icons.stop,
                    color: Colors.redAccent,
                    onTap: () async {
                      await ref.read(ttsSpeakerProvider.notifier).stop();
                    },
                    title: 'Stop'),
              ),
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
      ),
    );
  }
}
