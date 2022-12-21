import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/content_storage.dart';
import '../models/chapter.dart';
import '../models/repository.dart';
import 'words.dart';

class RepositoryNotifier extends StateNotifier<AsyncValue<Repository>> {
  RepositoryNotifier(this.ref, this.filename)
      : super(const AsyncValue.loading()) {
    load();
  }
  Ref ref;
  String filename;

  Future<void> _guard(Future<Repository> Function() func) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(func);
  }

  Future<void> load() async =>
      _guard(() async => Repository.loadFromFile(filename));

  Future<void> addChapter(Repository repository, Chapter chapter) async =>
      _guard(() async {
        await ref.read(wordsProvider(chapter.filename).notifier).reload();
        return repository.add(chapter, filename: filename);
      });

  Future<void> removeChapter(Repository repository, Chapter chapter) async =>
      _guard(() async {
        await ContentStorage.delete(chapter.filename);
        await ref.read(wordsProvider(chapter.filename).notifier).reload();

        return repository.remove(chapter, filename: filename);
      });
  Future<void> reset(Repository repository) async {
    final currentFiles = repository.files;
    for (final file in currentFiles) {
      await ContentStorage.delete(file);
      await ref.read(wordsProvider(file).notifier).reload();
    }
    await ContentStorage.delete('index.json');
    await load();
    return;
  }

  //log(string) => print(string);
  void log(String string) {}

  Future<bool> loadFromZip({
    required Repository repository,
    required String path,
    required String zipFileName,
    required bool overwrite,
  }) async {
    var repositoryLocal = repository;
    final inputStream = InputFileStream(zipFileName);
    final archive = ZipDecoder().decodeBuffer(inputStream);

    if (!archive.files.map((e) => e.name).contains('index.json')) {
      return false;
    }
    final indexFile = archive.files.where((e) => e.name == 'index.json').first;
    final outputStream = OutputFileStream('$path/index.new.json');
    indexFile.writeContent(outputStream);
    await outputStream.close();
    final indexJSON = await File('$path/index.new.json').readAsString();
    final newRepository = Repository.fromJson(indexJSON);
    var needSave = false;
    for (final file in archive.files.where((e) => e.name != 'index.json')) {
      if (file.isFile) {
        var overwriting = false;
        log('$file: ');
        if (File('$path/$file').existsSync()) {
          if (!overwrite) {
            log('$file: Skip ,as overwrite = $overwrite');
            continue;
          }
          overwriting = true;
        }
        if (overwriting) {
          //delete the file as it exists
          await ContentStorage.delete('$path/$file');
          try {
            final ch = repositoryLocal.chapters
                .where((element) => element.filename == file.name)
                .first;
            log('$file: deleting ${ch.filename}');

            needSave = true;
            repositoryLocal = await repositoryLocal.remove(ch);
          } on Exception {
            // ignore if the file don't exists
          }
        }

        {
          final ch = newRepository.chapters
              .where((element) => element.filename == file.name)
              .first;
          final outputStream = OutputFileStream('$path/$file');
          log('$file: creating $file');
          file.writeContent(outputStream);
          await outputStream.close();
          needSave = true;
          repositoryLocal = await repositoryLocal.add(ch);
        }
        await ref.read(wordsProvider(file.name).notifier).reload();
      }
    }
    if (needSave) {
      log('saving index.json');
      await repositoryLocal.save('index.json');
      log('reload index.json');
      await load();
    } else {
      log('nothing  new to update');
    }
    return true;
  }
  /* Future<void> addMoreWords(Repository repository, int index,
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
      }); */
}

final repositoryProvider = StateNotifierProvider.family<RepositoryNotifier,
    AsyncValue<Repository>, String>((ref, fileName) {
  return RepositoryNotifier(ref, fileName);
});

final repositoryPathProvider = FutureProvider<String>((ref) async {
  return ContentStorage.path;
});
