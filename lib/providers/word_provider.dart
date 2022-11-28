// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/words.dart';

class WordsNotifier extends StateNotifier<AsyncValue<Words>> {
  final String assetFile;
  WordsNotifier(this.assetFile) : super(const AsyncValue.loading()) {
    load();
  }

  load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final json = await rootBundle.loadString(assetFile);
      return Words.fromJson(json);
    });
  }

  previous(Words words) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (!words.isFirst) {
        return words.copyWith(index: words.index - 1);
      }
      return words;
    });
    await resetCurrentWord();
  }

  next(Words words) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (!words.isLast) {
        return words.copyWith(index: words.index + 1);
      }
      return words;
    });
    await resetCurrentWord();
  }

  recognizedWords(
      {required String spokenText, required Function() onSuccess}) async {
    Words? words = state.whenOrNull(data: (Words words) => words);
    if (words != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final spokenWords = spokenText.split(' ');
        if (spokenWords.isEmpty) return words;
        final wordList = words.words;
        final success = wordList[words.index].original.toLowerCase() ==
            spokenWords.last.toLowerCase();
        wordList[words.index] = wordList[words.index].copyWith(
            utterred: spokenWords.last,
            attempts: spokenWords.length,
            succeeded: success);

        return words.copyWith(words: wordList);
      });
      state.whenData((Words words) {
        if (words.words[words.index].succeeded) {
          onSuccess();
        }
      });
    }
  }

  resetCurrentWord() async {
    Words? words = state.whenOrNull(data: (Words words) => words);
    if (words != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final wordList = words.words;

        wordList[words.index] = wordList[words.index]
            .copyWith(utterred: '', attempts: 0, succeeded: false);

        return words.copyWith(words: wordList);
      });
    }
  }
}

final wordsProvider =
    StateNotifierProvider.family<WordsNotifier, AsyncValue<Words>, String>(
        (ref, wordListFile) => WordsNotifier(wordListFile));
