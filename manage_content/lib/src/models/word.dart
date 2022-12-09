// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Word {
  final String original;

  final int attempts;
  final bool succeeded;
  final bool report;
  Word(
      {required this.original,
      required this.attempts,
      required this.succeeded,
      required this.report});

  Word.fromString(this.original)
      : attempts = 0,
        succeeded = false,
        report = false;

  Word copyWith(
      {String? original,
      String? lastSpoken,
      int? attempts,
      bool? succeeded,
      bool? giveup,
      bool? isReported}) {
    return Word(
        original: original ?? this.original,
        attempts: attempts ?? this.attempts,
        succeeded: succeeded ?? this.succeeded,
        report: isReported ?? report);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'original': original,
      'attempts': attempts,
      'succeeded': succeeded,
      'report': report,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      original: map['original'] as String,
      attempts: (map.containsKey('attempts')) ? map['attempts'] as int : 0,
      succeeded:
          (map.containsKey('succeeded')) ? map['succeeded'] as bool : false,
      report: (map.containsKey('report')) ? map['report'] as bool : false,
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
    if (identical(this, other)) return true;

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
