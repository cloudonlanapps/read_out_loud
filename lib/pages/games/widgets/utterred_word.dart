import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/words.dart';
import '../../../providers/word_provider.dart';

class UtterredWord extends ConsumerWidget {
  const UtterredWord({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Words> wordsAsync = ref.watch(wordsProvider);

    return wordsAsync.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => const Center(
              child: Text("Unable to start the application, contact developer"),
            ),
        data: (Words words) => Column(
              children: [
                if (words.currentWord.utterred != '')
                  if (words.currentWord.succeeded)
                    Text(
                      "Well Done",
                      style: TextStyle(color: Colors.greenAccent.shade400),
                    )
                  else ...[
                    const Text("Did you say:"),
                    Text(
                      words.currentWord.utterred,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.redAccent.shade400),
                    )
                  ],
              ],
            ));
  }
}
