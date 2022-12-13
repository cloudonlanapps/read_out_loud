import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

class ShowExistingWords extends ConsumerWidget {
  final String wordsFilename;
  final List<Word> deletedWords;
  final Function(Word word) onDeleteWord;
  final Function(Word word) onRestoreDeletedWord;
  final List<String> addedWords;
  final Function(String string) onDeleteString;

  final bool readonly;
  const ShowExistingWords(
      {super.key,
      required this.wordsFilename,
      required this.readonly,
      required this.deletedWords,
      required this.addedWords,
      required this.onDeleteWord,
      required this.onDeleteString,
      required this.onRestoreDeletedWord});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAll = ref.watch(wordsProvider(wordsFilename));
    final words = wordsAll?.wordsIncludeReported
            .where((element) => !deletedWords.contains(element))
            .toList() ??
        [];

    if (words.isEmpty && addedWords.isEmpty && deletedWords.isEmpty) {
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
    return Column(
      children: [
        Wrap(spacing: 6.0, runSpacing: 6.0, children: <Widget>[
          for (Word word in words)
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
                onDeleted:
                    readonly || word.report ? null : () => onDeleteWord(word)),
        ]),
        if (addedWords.isNotEmpty) ...[
          const SizedBox(
            height: 8,
          ),
          const Divider(thickness: 1),
          Align(
              alignment: Alignment.centerLeft,
              child: Text("New Words",
                  style: Theme.of(context).textTheme.bodyMedium)),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: <Widget>[
              for (String string in addedWords)
                Chip(
                    backgroundColor: Colors.blue,
                    labelPadding: const EdgeInsets.all(2.0),
                    label: Text(string,
                        style: Theme.of(context).textTheme.labelLarge),
                    elevation: 6.0,
                    shadowColor: Colors.grey[60],
                    padding: const EdgeInsets.all(8.0),
                    onDeleted: readonly ? null : () => onDeleteString(string)),
            ],
          ),
        ],
        if (deletedWords.isNotEmpty) ...[
          const SizedBox(
            height: 8,
          ),
          const Divider(thickness: 1),
          Align(
              alignment: Alignment.centerLeft,
              child: Text("Deleted Words",
                  style: Theme.of(context).textTheme.bodyMedium)),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: <Widget>[
              for (Word word in deletedWords)
                Chip(
                  deleteIcon: const Icon(Icons.restart_alt_sharp),
                  backgroundColor: Colors.blue,
                  labelPadding: const EdgeInsets.all(2.0),
                  label: Text(word.original,
                      style: Theme.of(context).textTheme.labelLarge),
                  elevation: 6.0,
                  shadowColor: Colors.grey[60],
                  padding: const EdgeInsets.all(8.0),
                  onDeleted: readonly ? null : () => onRestoreDeletedWord(word),
                ),
            ],
          ),
        ]
      ],
    );
  }
}
/*
 */