import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';

import 'widgets/play_word.dart';
import 'providers/state_provider.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final ContentListConfig contentListConfig;
  const MainContent(
      {super.key, required this.contentListConfig, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Words? words = ref.watch(wordsProvider(contentListConfig.filename));
    if (words == null) {
      return Center(
        child: Text(
          "Nothing to show here",
          style: TextStyles.fullPageText(context),
        ),
      );
    }

    return PlayWord(
      key: ValueKey(words.currentWord!.original),
      size: size,
      word: words.currentWord!,
      contentListConfig: contentListConfig,
      words: words,
    );
  }
}
