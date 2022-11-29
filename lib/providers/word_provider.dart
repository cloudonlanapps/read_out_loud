// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/word.dart';
import '../models/words.dart';
import 'selected_list.dart';

class WordsNotifier extends StateNotifier<Words> {
  final String assetFile;
  WordsNotifier(this.assetFile) : super(Words()) {
    load();
  }

  load() async {
    final list = (const LineSplitter())
        .convert(await rootBundle.loadString("$assetFile.txt"));

    state = Words.fromList(list);
  }

  previous() async {
    final words = state;
    if (!words.isFirst) {
      state = words.copyWith(index: words.index - 1);
    }
  }

  next() async {
    final words = state;
    if (!words.isLast) {
      state = words.copyWith(index: words.index + 1);
    }
  }

  recognizedWords(
      {required String spokenText,
      required Function() onSuccess,
      required Function() onFail,
      required Function() introNextWord}) async {
    if (state.currentWord == null) {
      // Word not found in the list
      return;
    }

    final Word word = state.currentWord!;

    if (!word.succeeded) {
      final spokenWords = spokenText.split(' ');
      if (spokenWords.isEmpty) return;
      final wordList = state.words;
      final success = wordList[state.index].original.toLowerCase() ==
          spokenWords.last.toLowerCase();
      wordList[state.index] = wordList[state.index].copyWith(
          utterred: spokenWords.last,
          attempts: spokenWords.length,
          succeeded: success);

      state = state.copyWith(words: wordList);
    }
  }
}

final wordsProvider = StateNotifierProvider<WordsNotifier, Words>((ref) {
  final String wordListFile = ref.watch(selectedListProvider);
  return WordsNotifier(wordListFile);
});
