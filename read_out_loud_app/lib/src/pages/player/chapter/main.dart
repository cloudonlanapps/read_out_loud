import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';

import 'providers/state_provider.dart';
import 'widgets/play_word.dart';

class MainContent extends ConsumerWidget {
  const MainContent({
    required this.contentListConfig,
    required this.size,
    super.key,
  });
  final Size size;
  final ContentListConfig contentListConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(wordsProvider(contentListConfig.filename));
    if (words == null) {
      return Center(
        child: Text(
          'Nothing to show here',
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
