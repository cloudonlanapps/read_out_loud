import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:archive/archive_io.dart';

import '../helpers/content_storage.dart';
import '../models/chapter.dart';
import '../models/repository.dart';
import 'words.dart';

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
  Future<void> reset(Repository repository) async {
    final List<String> currentFiles = repository.files;
    for (var file in currentFiles) {
      await ContentStorage.delete(file);
      await ref.read(wordsProvider(file).notifier).reload();
    }
    await ContentStorage.delete("index.json");
    await load();
    return;
  }

  //log(string) => print(string);
  log(string) {}

  Future<bool> loadFromZip(
      {required Repository repository,
      required String path,
      required String zipFileName,
      required bool overwrite}) async {
    final inputStream = InputFileStream(zipFileName);
    final archive = ZipDecoder().decodeBuffer(inputStream);

    if (!archive.files.map((e) => e.name).contains("index.json")) {
      return false;
    }
    final indexFile = archive.files.where((e) => e.name == 'index.json').first;
    final outputStream = OutputFileStream('$path/index.new.json');
    indexFile.writeContent(outputStream);
    outputStream.close();
    final indexJSON = await File('$path/index.new.json').readAsString();
    Repository newRepository = Repository.fromJson(indexJSON);
    bool needSave = false;
    for (final file in archive.files.where((e) => e.name != 'index.json')) {
      if (file.isFile) {
        bool overwriting = false;
        log("$file: ");
        if (File('$path/$file').existsSync()) {
          if (!overwrite) {
            log("$file: Skip ,as overwrite = $overwrite");
            continue;
          }
          overwriting = true;
        }
        if (overwriting) {
          //delete the file as it exists
          await ContentStorage.delete('$path/$file');
          try {
            Chapter ch = repository.chapters
                .where((element) => element.filename == file.name)
                .first;
            log("$file: deleting ${ch.filename}");

            needSave = true;
            repository = await repository.remove(ch);
          } catch (e) {
            // ignore if the file don't exists
          }
        }

        {
          Chapter ch = newRepository.chapters
              .where((element) => element.filename == file.name)
              .first;
          final outputStream = OutputFileStream('$path/$file');
          log("$file: creating $file");
          file.writeContent(outputStream);
          outputStream.close();
          needSave = true;
          repository = await repository.add(ch);
        }
        await ref.read(wordsProvider(file.name).notifier).reload();
      }
    }
    if (needSave) {
      log("saving index.json");
      await repository.save('index.json');
      log("reload index.json");
      await load();
    } else {
      log("nothing  new to update");
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
  return await ContentStorage.path;
});
