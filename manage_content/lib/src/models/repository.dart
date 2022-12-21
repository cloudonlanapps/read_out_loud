// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../helpers/content_storage.dart';
import 'chapter.dart';

@immutable
class Repository {
  final List<Chapter> chapters;
  const Repository({
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
    if (identical(this, other)) {
      return true;
    }

    return const ListEquality().equals(other.chapters, chapters);
  }

  @override
  int get hashCode => chapters.hashCode;

  Future<Repository> add(Chapter newChapter, {String? filename}) async {
    final updated = copyWith(chapters: [...chapters, newChapter]);
    await updated.save(filename);
    return updated;
  }

  Future<Repository> remove(Chapter chapter, {String? filename}) async {
    final updated = copyWith(
      chapters: chapters.where((element) => element != chapter).toList(),
    );
    await updated.save(filename);
    return updated;
  }

  Future<Repository> update(
    int index,
    Chapter chapter, {
    String? filename,
  }) async {
    final chaptersLocal = chapters;
    chaptersLocal[index] = chapter;
    final updated = copyWith(chapters: chaptersLocal);
    await updated.save(filename);
    return updated;
  }

  bool get isEmpty => chapters.isEmpty;

  static Future<Repository> loadFromFile(String filename) async {
    final json = await ContentStorage.loadString(filename);
    return Repository.fromJson(json);
  }

  Future<void> save(String? filename) async {
    if (filename != null) {
      await ContentStorage.saveString(filename, toJson());
    }
  }

  List<String> get files {
    return [...chapters.map((e) => e.filename).toList()];
  }

  /// If older zip file exists already, delete
  /// zip all the files
  /// return the filename
  Future<String?> archive(String dir, String archiveName) async {
    try {
      final zipFile = '$dir/$archiveName';
      if (File(zipFile).existsSync()) {
        await File(zipFile).delete();
      }
      final encoder = ZipFileEncoder()..create(zipFile);
      for (final file in [
        ...files,
        'index.json',
      ]) {
        if (File('$dir/$file').existsSync()) {
          await encoder.addFile(File('$dir/$file'));
        }
      }
      encoder.close();
      return zipFile;
    } on Exception {
      return null;
    }
  }
}
