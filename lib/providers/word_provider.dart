// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/word.dart';
import '../models/words.dart';
import 'selected_list.dart';

class WordsNotifier extends StateNotifier<Words?> {
  final String assetFile;
  WordsNotifier(this.assetFile) : super(null) {
    load();
  }

  load() async {
    final list = (const LineSplitter())
        .convert(await rootBundle.loadString("$assetFile.txt"));

    state = Words.fromList(list);
  }

  previous() async {
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
          utterred: spokenWords.last,
          attempts: spokenWords.length,
          succeeded: success);

      state = state!.copyWith(words: wordList);
    }
  }
}

final wordsProvider = StateNotifierProvider<WordsNotifier, Words?>((ref) {
  final String wordListFile = ref.watch(selectedListProvider);
  return WordsNotifier(wordListFile);
});
