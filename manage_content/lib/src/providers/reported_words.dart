import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

final reportedWordsProvider = Provider<List<String>?>((ref) {
  final asyncValue = ref.watch(repositoryProvider('index.json'));

  return asyncValue.whenOrNull(
    data: (repository) {
      final words = <String>[];

      for (final chapter in repository.chapters) {
        final curr = ref.watch(wordsProvider(chapter.filename))?.reported;
        if (curr != null) {
          words.addAll(curr);
        }
      }
      return words;
    },
  );
});
