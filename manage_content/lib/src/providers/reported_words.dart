import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

final reportedWordsProvider = Provider<List<String>?>((ref) {
  AsyncValue<Repository> asyncValue =
      ref.watch(repositoryProvider('index.json'));

  return asyncValue.whenOrNull(data: (Repository repository) {
    List<String> words = [];

    for (Chapter chapter in repository.chapters) {
      final List<String>? curr =
          ref.watch(wordsProvider(chapter.filename))?.reported;
      if (curr != null) {
        words.addAll(curr);
      }
    }
    return words;
  });
});
