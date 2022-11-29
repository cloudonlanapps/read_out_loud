// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/words.dart';
import 'selected_list.dart';

class WordsNotifier extends StateNotifier<Words?> {
  final String assetFile;
  WordsNotifier(this.assetFile) : super(null) {
    load();
  }

  load() async {
    /* final list = (const LineSplitter())
          .convert(await rootBundle.loadString("$assetFile.txt"));
      return Words.fromList(list); */

    final json = await rootBundle.loadString(assetFile);
    state = Words.fromJson(json);
  }

  previous() {
    if (state != null) {
      final obj = state!;
      if (obj.isNotEmpty && !obj.isFirst) {
        state = obj.copyWith(index: obj.index - 1);
      }
    }
  }

  next() {
    if (state != null) {
      final obj = state!;
      if (obj.isNotEmpty && !obj.isLast) {
        state = obj.copyWith(index: obj.index + 1);
      }
    }
  }

  recognizedWords(
      {required String spokenText,
      required Function() onSuccess,
      required Function() onFail,
      required Function() introNextWord}) {
    if (state == null) return;
    final obj = state!;
    final spokenWords = spokenText.split(' ');
    if (spokenWords.isNotEmpty) {
      final wordList = obj.words;
      final success = wordList[obj.index].original.toLowerCase() ==
          spokenWords.last.toLowerCase();
      wordList[obj.index] = wordList[obj.index].copyWith(
          utterred: spokenWords.last,
          attempts: spokenWords.length,
          succeeded: success);

      state = obj.copyWith(words: wordList);
    }
  }

  resetCurrentWord() async {
    if (state == null) return;
    final obj = state!;
    final wordList = obj.words;

    wordList[obj.index] = wordList[obj.index]
        .copyWith(utterred: '', attempts: 0, succeeded: false);

    return obj.copyWith(words: wordList);
  }
}

final wordsProvider = StateNotifierProvider<WordsNotifier, Words?>((ref) {
  final String wordListFile = ref.watch(selectedListProvider);
  return WordsNotifier(wordListFile);
});
