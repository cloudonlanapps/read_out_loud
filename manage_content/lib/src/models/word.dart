// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class Word {
  final String original;

  final int attempts;
  final bool succeeded;
  final bool report;
  const Word({
    required this.original,
    required this.attempts,
    required this.succeeded,
    required this.report,
  });

  const Word.fromString(this.original)
      : attempts = 0,
        succeeded = false,
        report = false;

  Word copyWith({
    String? original,
    String? lastSpoken,
    int? attempts,
    bool? succeeded,
    bool? giveup,
    bool? isReported,
  }) {
    return Word(
      original: original ?? this.original,
      attempts: attempts ?? this.attempts,
      succeeded: succeeded ?? this.succeeded,
      report: isReported ?? report,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'word': original,
      'attempts': attempts,
      'succeeded': succeeded,
      'report': report,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    var succeeded = false;
    var reported = false;
    if (map.containsKey('succeeded')) {
      succeeded = map['succeeded'] as bool;
    }
    if (map.containsKey('report')) {
      reported = map['report'] as bool;
    }

    return Word(
      original: map['word'] as String,
      attempts: (map.containsKey('attempts')) ? map['attempts'] as int : 0,
      succeeded: succeeded,
      report: reported,
    );
  }

  String toJson() => json.encode(toMap());

  factory Word.fromJson(String source) =>
      Word.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Word(original: $original, attempts: $attempts, succeeded: $succeeded, report: $report)';
  }

  @override
  bool operator ==(covariant Word other) {
    if (identical(this, other)) {
      return true;
    }

    return other.original == original &&
        other.attempts == attempts &&
        other.succeeded == succeeded &&
        other.report == report;
  }

  @override
  int get hashCode {
    return original.hashCode ^
        attempts.hashCode ^
        succeeded.hashCode ^
        report.hashCode;
  }
}
