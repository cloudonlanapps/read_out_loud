import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../models/words.dart';
import '../../../providers/word_provider.dart';
import '../../custom_widgets/circular_button.dart';
import '../../custom_widgets/menu_button.dart';

class BottomMenu extends ConsumerWidget {
  final Function() onTapRecord;
  final SpeechToText speechToText;
  final bool speechEnabled;
  final String wordListFile;
  const BottomMenu(
      {super.key,
      required this.onTapRecord,
      required this.speechEnabled,
      required this.speechToText,
      required this.wordListFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Words> wordsAsync = ref.watch(wordsProvider(wordListFile));
    return wordsAsync.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => const Center(
              child: Text("Unable to start the application, contact developer"),
            ),
        data: (Words words) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: MenuButton(
                    height: 20,
                    menuButtonItem: MenuButtonItem(
                        icon: Icons.arrow_circle_left,
                        onTap: () async {
                          await ref
                              .read(wordsProvider(wordListFile).notifier)
                              .previous(words);
                        },
                        title: 'Prev'),
                  ),
                ),
                if (speechEnabled)
                  CircularButton(
                    height: 20,
                    backgroundColor:
                        speechToText.isListening ? Colors.red.shade400 : null,
                    menuButtonItem: CircularButtonItem(
                        icon: speechToText.isNotListening
                            ? Icons.mic
                            : Icons.mic_off,
                        onTap: onTapRecord,
                        title: speechToText.isListening ? "Done" : "Talk"),
                  )
                else
                  CircleAvatar(
                    backgroundColor:
                        speechToText.isListening ? Colors.red.shade400 : null,
                    child: const CircularProgressIndicator(),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: MenuButton(
                    height: 20,
                    menuButtonItem: MenuButtonItem(
                        icon: Icons.arrow_circle_right,
                        onTap: () async {
                          await ref
                              .read(wordsProvider(wordListFile).notifier)
                              .next(words);
                        },
                        title: 'Next'),
                  ),
                ),
              ],
            ));
  }
}
