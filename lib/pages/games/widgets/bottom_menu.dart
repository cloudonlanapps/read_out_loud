import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud/models/tts.dart';

import '../../../models/speech_recogn.dart';
import '../../../models/words.dart';
import '../../../providers/word_provider.dart';
import '../../custom_widgets/circular_button.dart';
import '../../custom_widgets/menu_button.dart';

class BottomMenu extends ConsumerStatefulWidget {
  const BottomMenu({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomMenuState();
}

class _BottomMenuState extends ConsumerState<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    SpeechRecog speechRecog = ref.watch(speechRecogProvider);
    TTSpeech ttSpeech = ref.watch(ttspeechProvider);
    Words? words = ref.watch(wordsProvider);
    if (words == null || ttSpeech.isSpeaking) return Container();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: MenuButton(
            height: 20,
            menuButtonItem: MenuButtonItem(
                icon: Icons.arrow_circle_left,
                onTap: () {
                  ref.read(speechRecogProvider.notifier).previous();
                },
                title: 'Prev'),
          ),
        ),
        if (speechRecog.speechEnabled)
          CircularButton(
            height: 20,
            backgroundColor:
                speechRecog.isListening ? Colors.red.shade400 : null,
            menuButtonItem: CircularButtonItem(
                icon: speechRecog.isNotListening ? Icons.mic : Icons.mic_off,
                onTap: () {},
                title: speechRecog.isListening ? "Done" : "Talk"),
          )
        else
          CircleAvatar(
            backgroundColor:
                speechRecog.isListening ? Colors.red.shade400 : null,
            child: const CircularProgressIndicator(),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: MenuButton(
            height: 20,
            menuButtonItem: MenuButtonItem(
                icon: Icons.arrow_circle_right,
                onTap: () {
                  ref.read(speechRecogProvider.notifier).next();
                },
                title: 'Next'),
          ),
        ),
      ],
    );
  }
}
