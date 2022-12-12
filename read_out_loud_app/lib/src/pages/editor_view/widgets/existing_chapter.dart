import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'words_editor.dart';

class ChapterEditor extends ConsumerWidget {
  final Repository repository;
  final int index;
  const ChapterEditor(
      {super.key, required this.repository, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(wordsProvider(repository.chapters[index].filename));
    if (words == null) {
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
    return FutureBuilder(
      future: isReadOnly(repository.chapters[index].filename),
      builder: (BuildContext build, AsyncSnapshot snapshot) {
        bool readOnly = !snapshot.hasData || snapshot.data as bool;

        return WordsEditor(
            key: ObjectKey(words),
            words: words,
            onSave: readOnly ? null : (Words words) {});
      },
    );
  }

  Future<bool> isReadOnly(filename) async =>
      await ContentStorage.hasAsset(filename);
}
