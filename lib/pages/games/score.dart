import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/words.dart';

class Score extends ConsumerWidget {
  final Words words;
  const Score({super.key, required this.words});

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
