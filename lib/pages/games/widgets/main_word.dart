import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/tts.dart';
import '../../../models/words.dart';
import '../../../providers/word_provider.dart';

class MainWord extends ConsumerWidget {
  const MainWord({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Words> wordsAsync = ref.watch(wordsProvider);
    final TTSpeech ttspeech = ref.watch(ttspeechProvider);
    return wordsAsync.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Center(
              child: Column(
                children: [
                  const Text(
                      "Unable to start the application, contact developer"),
                  Text(error.toString())
                ],
              ),
            ),
        data: ((Words words) => InkWell(
              onTap: ttspeech.ready
                  ? () => ref
                      .read(ttspeechProvider.notifier)
                      .speak(words.currentWord.original)
                  : null,
              child: DottedBorder(
                  //dashPattern: const [6, 3, 2, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        child: FittedBox(
                          child: Text(
                            words.currentWord.original,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))),
            )));
  }
}
