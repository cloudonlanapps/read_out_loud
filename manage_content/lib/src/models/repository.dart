// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:collection/collection.dart';

import 'chapter.dart';

class Repository {
  final List<Chapter> chapters;
  Repository({
    required this.chapters,
  });

  Repository copyWith({
    List<Chapter>? chapters,
  }) {
    return Repository(
      chapters: chapters ?? this.chapters,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chapters': chapters.map((x) => x.toMap()).toList(),
    };
  }

  factory Repository.fromMap(Map<String, dynamic> map) {
    return Repository(
      chapters: List<Chapter>.from(
        (map['chapters'] as List<dynamic>).map<Chapter>(
          (x) => Chapter.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Repository.fromJson(String source) =>
      Repository.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Repository(chapters: $chapters)';

  @override
  bool operator ==(covariant Repository other) {
    Function eq = const ListEquality().equals;
    if (identical(this, other)) return true;

    return eq(other.chapters, chapters);
  }

  @override
  int get hashCode => chapters.hashCode;

  add(Chapter newChapter) {
    return copyWith(chapters: [...chapters, newChapter]);
  }

  remove(Chapter chapter) {
    return copyWith(
        chapters: chapters.where((element) => element != chapter).toList());
  }

  bool get isEmpty => chapters.isEmpty;
}
