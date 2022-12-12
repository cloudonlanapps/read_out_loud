// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../helpers/content_storage.dart';
import 'word.dart';

enum WordFilter { all, excludeReported }

class Words {
  final List<Word> _words;
  final String title;
  final int index;
  final WordFilter wordFilter;
  Words(
      {required List<Word> words,
      required this.title,
      int? index,
      this.wordFilter = WordFilter.excludeReported})
      : index = ((index != null) &&
                (index >= 0) &&
                (index <
                    words
                        .where((e) {
                          return wordFilter == WordFilter.all || !e.report;
                        })
                        .toList()
                        .length))
            ? index
            : 0,
        _words = words;

  Words copyWith({
    List<Word>? words,
    String? title,
    int? index,
  }) {
    return Words(
      words: words ?? _words,
      title: title ?? this.title,
      index: index ?? this.index,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'words': _words.map((x) => x.toMap()).toList(),
      'title': title,
    };
  }

  factory Words.fromMap(Map<String, dynamic> map) {
    return Words(
      words: List<Word>.from(
        (map['words'] as List<dynamic>).map<Word>(
          (x) => Word.fromMap(x as Map<String, dynamic>),
        ),
      ),
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Words.fromJson(String source) =>
      Words.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Words(words: $_words, title: $title, index: $index)';

  @override
  bool operator ==(covariant Words other) {
    if (identical(this, other)) return true;

    return listEquals(other._words, _words) &&
        other.title == title &&
        other.index == index;
  }

  @override
  int get hashCode => _words.hashCode ^ title.hashCode ^ index.hashCode;

  Word? get currentWord =>
      (words.length > index && index >= 0) ? words[index] : null;

  bool get isFirst => (index == 0);

  bool get isLast => (index == words.length - 1);

  int get successCount =>
      words.where((Word e) => e.succeeded == true).toList().length;

  int get reportCount =>
      _words.where((Word e) => e.report == true).toList().length;

  List<String> get reported => _words
      .where((Word e) => e.report == true)
      .map((e) => e.original)
      .toList();

  int get totalCount => words.length;

  double get progress =>
      totalCount > 0 ? successCount.toDouble() / totalCount.toDouble() : 0.0;

  List<Word> get words => _words.where((e) {
        return wordFilter == WordFilter.all || !e.report;
      }).toList();
  List<Word> get wordsIncludeReported => _words;

  Words reportCurrentWord() {
    final wordList = _words;
    if (currentWord != null) {
      wordList[wordList.indexOf(currentWord!)] =
          currentWord!.copyWith(isReported: true);

      final nextIndex = isLast ? index - 1 : index;
      return copyWith(words: wordList, index: nextIndex);
    }
    return this;
  }

  Words clearProgress() {
    final wordList =
        _words.map((e) => e.copyWith(succeeded: false, attempts: 0)).toList();
    return copyWith(words: wordList);
  }

  Word getWordByString(String string) {
    try {
      return _words.where((element) => element.original == string).first;
    } catch (e) {
      return Word.fromString(string);
    }
  }

  Words addMoreWords(List<String> newWords) {
    List<String> allWordsOriginal =
        {..._words.map((e) => e.original).toList(), ...newWords}.toList();

    return copyWith(
        words: allWordsOriginal.map((e) => getWordByString(e)).toList());
  }

  Words deleteWords(List<Word> wordsList) {
    return copyWith(
        words:
            _words.where((element) => !wordsList.contains(element)).toList());
  }

  Words newTitle(String title) {
    return copyWith(title: title);
  }

  static Future<Words> loadFromFile(filename) async {
    String json = await ContentStorage.loadString(filename);

    try {
      return Words.fromJson(json);
    } catch (e) {
      throw Exception("Error parsing $filename ${e.toString()}");
    }
  }

  save(String? filename) async {
    if (filename != null) await ContentStorage.saveString(filename, toJson());
  }
}
