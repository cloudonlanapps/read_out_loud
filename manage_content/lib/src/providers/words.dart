// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../models/word.dart';
import '../models/words.dart';

class WordsNotifier extends StateNotifier<Words?> {
  Ref ref;
  final String filename;
  WordsNotifier(this.ref, this.filename) : super(null) {
    load();
  }

  load() async {
    final String? json = await loadString(filename);
    if (json != null) {
      state = Words.fromJson(json);
    }
  }

  static Future<String?> loadString(String filename) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File file = await install(
        assetFile: "assets/$filename.txt", storageFile: "$path/$filename.json");
    if (file.existsSync()) {
      return file.readAsString();
    }
    return null;
  }

  updateState(Words words) async {
    await save();
    state = words;
  }

  save() async {
    if (state != null) {
      final String path = (await getApplicationDocumentsDirectory()).path;
      String json = state!.toJson();
      await File("$path/$filename.json").writeAsString(json);
    }
  }

  static Future<File> install(
      {required String assetFile, required String storageFile}) async {
    File? file = File(storageFile);
    if (!file.existsSync()) {
      try {
        final list = (const LineSplitter())
            .convert(await rootBundle.loadString(assetFile));
        Words words = Words.fromList(list);

        File file = await File(storageFile).create(recursive: true);

        file.writeAsString(words.toJson());

        return file;
      } catch (e) {
        return file;
      }
    }
    return file;
  }

  prev() async {
    if (state == null) return;
    final words = state!;
    if (!words.isFirst) {
      await updateState(words.copyWith(index: words.index - 1));
    }
  }

  next() async {
    if (state == null) return;
    final words = state!;
    if (!words.isLast) {
      await updateState(words.copyWith(index: words.index + 1));
    }
  }

  // Not used
  recognizedWords({
    required String spokenText,
  }) async {
    final spokenWords = spokenText.split(' ');
    if (spokenWords.isEmpty) return;
    String spokenWord = spokenWords.last.toLowerCase();

    if (state?.currentWord == null) {
      return;
    }

    final Word word = state!.currentWord!;
    if (!word.succeeded) {
      final wordList = state!.words;
      final success =
          wordList[state!.index].original.toLowerCase() == spokenWord;
      wordList[state!.index] = wordList[state!.index].copyWith(
          lastSpoken: spokenWords.last,
          attempts: spokenWords.length,
          succeeded: success);

      await updateState(state!.copyWith(words: wordList));
    }
  }

  attempted(Word word) async {
    final wordList = state!.words;
    wordList[wordList.indexOf(word)] =
        word.copyWith(attempts: word.attempts + 1);

    await updateState(state!.copyWith(words: wordList));
  }

  success(Word word) async {
    final wordList = state!.words;
    if (word.succeeded) {
      wordList[wordList.indexOf(word)] = word.copyWith(succeeded: true);
    } else {
      wordList[wordList.indexOf(word)] =
          word.copyWith(succeeded: true, attempts: word.attempts + 1);
    }
    await updateState(state!.copyWith(words: wordList));
  }

  reportCurrentWord() async {
    if (state != null) {
      await updateState(state!.reportCurrentWord());
    }
  }

  clearProgress() async {
    if (state != null) {
      await updateState(state!.clearProgress());
    }
  }
}

final wordsProvider =
    StateNotifierProvider.family<WordsNotifier, Words?, String>(
        (ref, filename) {
  return WordsNotifier(ref, filename);
});
