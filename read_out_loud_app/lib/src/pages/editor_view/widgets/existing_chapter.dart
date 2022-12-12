import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import '../../../custom_widgets/words_editor.dart';

class ChapterEditor extends ConsumerWidget {
  final Repository repository;
  final int index;
  const ChapterEditor(
      {super.key, required this.repository, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter =
        ref.watch(wordsProvider(repository.chapters[index].filename));
    if (chapter == null) {
      return const Center(
        child: Text(
          "This chapter seems missing, do you want to create one?",
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Horizon',
          ),
        ),
      );
    }
    return WordsEditor(
      title: chapter.title,
      existingWords: chapter.words.map((e) => e.original).toList(),
    );
  }
}
