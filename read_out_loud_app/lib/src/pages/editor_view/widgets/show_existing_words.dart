import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

class ShowExistingWords extends ConsumerWidget {
  final String wordsFilename;

  final bool readonly;
  const ShowExistingWords({
    super.key,
    required this.wordsFilename,
    required this.readonly,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(wordsProvider(wordsFilename));
    if (words == null || words.words.isEmpty) {
      return const Center(
        child: Text(
          "This is an empty list, add more words ",
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Horizon',
          ),
        ),
      );
    }
    return Wrap(spacing: 6.0, runSpacing: 6.0, children: <Widget>[
      for (Word word in words.wordsIncludeReported)
        Chip(
            backgroundColor: word.succeeded ? Colors.lightGreen : null,
            labelPadding: const EdgeInsets.all(2.0),
            label: Text(word.original,
                style: (word.report)
                    ? Theme.of(context).textTheme.labelLarge!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 3,
                          decorationColor: Colors.redAccent,
                        )
                    : Theme.of(context).textTheme.labelLarge),
            elevation: 6.0,
            shadowColor: Colors.grey[60],
            padding: const EdgeInsets.all(8.0),
            onDeleted: readonly || word.report
                ? null
                : () async {
                    await ref
                        .read(wordsProvider(wordsFilename).notifier)
                        .removeWords([word]);
                  }),
    ]);
  }
}
