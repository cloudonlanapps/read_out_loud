// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../models/word.dart';
import '../models/words.dart';

class WordsNotifier extends StateNotifier<Words?> {
  final String filename;
  WordsNotifier(this.filename) : super(null) {
    load();
  }

  load() async {
    final String json = await loadString(filename);
    state = Words.fromJson(json);
  }

  static Future<String> loadString(String filename) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File file = await install(
        assetFile: "assets/$filename.txt", storageFile: "$path/$filename.json");
    return file.readAsString();
  }

  static Future<File> install(
      {required String assetFile, required String storageFile}) async {
    File? file = File(storageFile);
    if (!file.existsSync()) {
      final list = (const LineSplitter())
          .convert(await rootBundle.loadString(assetFile));
      Words words = Words.fromList(list);

      File file = await File(storageFile).create(recursive: true);

      file.writeAsString(words.toJson());

      return file;
    }
    return file;
  }

  prev() async {
    if (state == null) return;
    final words = state!;
    if (!words.isFirst) {
      state = words.copyWith(index: words.index - 1);
    }
  }

  next() async {
    if (state == null) return;
    final words = state!;
    if (!words.isLast) {
      state = words.copyWith(index: words.index + 1);
    }
  }

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

      state = state!.copyWith(words: wordList);
    }
  }

  success(Word word) {
    final wordList = state!.words;
    wordList[wordList.indexOf(word)] =
        word.copyWith(succeeded: true, attempts: word.attempts + 1);

    state = state!.copyWith(words: wordList);
  }

  reportCurrentWord() {
    if (state != null) {
      state = state!.reportCurrentWord();
    }
  }
}

final wordsProvider =
    StateNotifierProvider.family<WordsNotifier, Words?, String>(
        (ref, filename) {
  return WordsNotifier(filename);
});
