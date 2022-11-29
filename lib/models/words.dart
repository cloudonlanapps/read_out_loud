// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'word.dart';

class Words {
  final List<Word> words;
  final String title;
  final int index;
  Words({
    List<Word>? words,
    String? title,
    int? index,
  })  : words = words ?? [],
        title = title ?? "",
        index = index ?? ((words == null) ? -1 : 0);

  Words copyWith({
    List<Word>? words,
    String? title,
    int? index,
  }) {
    return Words(
      words: words ?? this.words,
      title: title ?? this.title,
      index: index ?? this.index,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'words': words.map((x) => x.toMap()).toList(),
      'title': title,
      'index': index,
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
      index: (map.containsKey('index')) ? map['index'] as int : 0,
    );
  }
  factory Words.fromList(List list, {String title = "Unknown List"}) {
    return Words(
      words: list.map((e) => Word.fromString(e)).toList(),
      title: title,
      index: 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Words.fromJson(String source) =>
      Words.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Words(words: $words, title: $title, index: $index)';

  @override
  bool operator ==(covariant Words other) {
    if (identical(this, other)) return true;

    return listEquals(other.words, words) &&
        other.title == title &&
        other.index == index;
  }

  @override
  int get hashCode => words.hashCode ^ title.hashCode ^ index.hashCode;

  Word? get currentWord =>
      (words.length > index && index >= 0) ? words[index] : null;

  bool get isFirst => (index == 0) || (index == -1);

  bool get isLast => (index == words.length - 1) || (index == -1);

  int get successCount =>
      words.where((Word e) => e.succeeded == true).toList().length;
}
