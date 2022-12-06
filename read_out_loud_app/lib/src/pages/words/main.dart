import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import 'play_word.dart';
import 'state_provider.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final ContentListConfig contentListConfig;
  const MainContent(
      {super.key, required this.contentListConfig, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Words? words = ref.watch(wordsProvider(contentListConfig.filename));
    if (words == null) {
      return const Center(
        child: Text(
          "Nothing to show here",
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Horizon',
          ),
        ),
      );
    }

    return PlayWord(
        key: ObjectKey(words.currentWord!),
        size: size,
        word: words.currentWord!);
  }
}
