// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/word.dart';
import '../models/words.dart';

class WordsNotifier extends StateNotifier<Words?> {
  Ref ref;
  final String filename;
  WordsNotifier(this.ref, this.filename) : super(null) {
    load();
  }

  load() async {
    try {
      state = await Words.loadFromFile(filename);
    } catch (e) {
      state = null;
    }
  }

  reload() async {
    state = null;
    try {
      state = await Words.loadFromFile(filename);
    } catch (e) {
      state = null;
    }
  }

  updateState(Words words) async {
    await save();
    state = words;
  }

  save() async => await state?.save(filename);

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

  Future<void> updateWords(
      {required List<Word> wordListToRemove,
      required List<String> newWordStrings}) async {
    final Words? updated = state?.updateWords(
        wordListToRemove: wordListToRemove, newWordStrings: newWordStrings);
    await updated?.save(filename);
    state = updated;
  }
}

final wordsProvider =
    StateNotifierProvider.family<WordsNotifier, Words?, String>(
        (ref, filename) {
  return WordsNotifier(ref, filename);
});
