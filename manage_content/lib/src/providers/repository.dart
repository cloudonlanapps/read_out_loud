import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

class RepositoryNotifier extends StateNotifier<AsyncValue<Repository>> {
  Ref ref;
  String filename;
  RepositoryNotifier(this.ref, this.filename)
      : super(const AsyncValue.loading()) {
    load();
  }

  _guard(Future<Repository> Function() func) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(func);
  }

  Future<void> load() async =>
      await _guard(() async => await Repository.loadFromFile(filename));

  Future<void> addChapter(Repository repository, Chapter chapter) async =>
      await _guard(() async {
        await ref.read(wordsProvider(chapter.filename).notifier).reload();
        return await repository.add(chapter, filename: filename);
      });

  Future<void> removeChapter(Repository repository, Chapter chapter) async =>
      await _guard(() async {
        await ContentStorage.delete(chapter.filename);
        await ref.read(wordsProvider(chapter.filename).notifier).reload();

        return await repository.remove(chapter, filename: filename);
      });

  Future<void> addMoreWords(Repository repository, int index,
          List<String> newWordStrings) async =>
      await _guard(() async {
        Chapter currChapter = repository.chapters[index];

        final Words? updated = ref
            .read(wordsProvider(currChapter.filename))
            ?.addMoreWords(newWordStrings);

        await updated?.save(currChapter.filename);

        await ref.read(wordsProvider(currChapter.filename).notifier).reload();

        return repository;
      });

  Future<void> removeWords(Repository repository, int index,
          List<Word> wordListToRemove) async =>
      await _guard(() async {
        Chapter currChapter = repository.chapters[index];

        final Words? updated = ref
            .read(wordsProvider(currChapter.filename))
            ?.deleteWords(wordListToRemove);
        await updated?.save(currChapter.filename);
        await ref.read(wordsProvider(currChapter.filename).notifier).reload();

        return repository;
      });
}

final repositoryProvider = StateNotifierProvider.family<RepositoryNotifier,
    AsyncValue<Repository>, String>((ref, fileName) {
  return RepositoryNotifier(ref, fileName);
});

final repositoryPathProvider = FutureProvider<String>((ref) async {
  return await ContentStorage.path;
});
