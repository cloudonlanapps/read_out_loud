import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/words.dart';
import '../../providers/word_provider.dart';

class Score extends ConsumerWidget {
  const Score({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Words> wordsAsync = ref.watch(wordsProvider);
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
        data: (Words words) => _Score(
              words: words,
            ));
  }
}

class _Score extends ConsumerWidget {
  final Words words;
  const _Score({required this.words});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text.rich(TextSpan(children: [
      const TextSpan(text: "Score: "),
      if (words.successCount > 0)
        TextSpan(text: "${words.successCount} / ${words.words.length}")
      else
        const TextSpan(text: "___"),
    ]));
  }
}
