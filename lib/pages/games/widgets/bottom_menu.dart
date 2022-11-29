import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/words.dart';
import '../../../providers/word_provider.dart';
import '../../custom_widgets/menu_button.dart';

class BottomMenu extends ConsumerStatefulWidget {
  const BottomMenu({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomMenuState();
}

class _BottomMenuState extends ConsumerState<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    //SpeechRecog speechRecog = ref.watch(speechRecogProvider);
    Words wordsAsync = ref.watch(wordsProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: MenuButton(
            height: 20,
            menuButtonItem: MenuButtonItem(
                icon: Icons.arrow_circle_left,
                onTap: () async {
                  await ref.read(wordsProvider.notifier).previous();
                },
                title: 'Prev'),
          ),
        ),
        /* if (speechRecog.speechEnabled)
                  CircularButton(
                    height: 20,
                    backgroundColor:
                        speechRecog.isListening ? Colors.red.shade400 : null,
                    menuButtonItem: CircularButtonItem(
                        icon: speechRecog.isNotListening
                            ? Icons.mic
                            : Icons.mic_off,
                        onTap: () => ref
                            .read(speechRecogProvider.notifier)
                            .toggleListening(),
                        title: speechRecog.isListening ? "Done" : "Talk"),
                  )
                else */
        const CircleAvatar(
          /* backgroundColor:
                      speechRecog.isListening ? Colors.red.shade400 : null, */
          child: CircularProgressIndicator(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 32.0),
          child: MenuButton(
            height: 20,
            menuButtonItem: MenuButtonItem(
                icon: Icons.arrow_circle_right,
                onTap: () async {
                  await ref.read(wordsProvider.notifier).next();
                },
                title: 'Next'),
          ),
        ),
      ],
    );
  }
}
