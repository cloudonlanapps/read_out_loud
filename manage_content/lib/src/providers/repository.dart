import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

class RepositoryNotifier extends StateNotifier<AsyncValue<Repository>> {
  String filename;
  RepositoryNotifier(this.filename) : super(const AsyncValue.loading()) {
    load();
  }

  _guard(Future<Repository> Function() func) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(func);
  }

  Future<void> load() async =>
      await _guard(() async => await Repository.loadFromFile(filename));

  Future<void> addChapter(Repository repository, Chapter chapter) async =>
      await _guard(
          () async => await repository.add(chapter, filename: filename));

  Future<void> removeChapter(Repository repository, Chapter chapter) async =>
      await _guard(
          () async => await repository.remove(chapter, filename: filename));

  Future<void> updateChapter(
          Repository repository, int index, Chapter chapter) async =>
      await _guard(() async =>
          await repository.update(index, chapter, filename: filename));
}

final repositoryProvider = StateNotifierProvider.family<RepositoryNotifier,
    AsyncValue<Repository>, String>((ref, fileName) {
  return RepositoryNotifier(fileName);
});

final repositoryPathProvider = FutureProvider<String>((ref) async {
  return await ContentStorage.path;
});
