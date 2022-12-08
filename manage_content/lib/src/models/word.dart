// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Word {
  final String original;
  final String lastSpoken;
  final int attempts;
  final bool succeeded;
  final bool giveup;
  final bool isReported;
  Word(
      {required this.original,
      required this.lastSpoken,
      required this.attempts,
      required this.succeeded,
      required this.giveup,
      required this.isReported});

  Word.fromString(this.original)
      : lastSpoken = "",
        attempts = 0,
        succeeded = false,
        giveup = false,
        isReported = false;

  Word copyWith(
      {String? original,
      String? lastSpoken,
      int? attempts,
      bool? succeeded,
      bool? giveup,
      bool? isReported}) {
    return Word(
        original: original ?? this.original,
        lastSpoken: lastSpoken ?? this.lastSpoken,
        attempts: attempts ?? this.attempts,
        succeeded: succeeded ?? this.succeeded,
        giveup: giveup ?? this.giveup,
        isReported: isReported ?? this.isReported);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'original': original,
      'utterred': lastSpoken,
      'attempts': attempts,
      'succeeded': succeeded,
      'giveup': giveup,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      original: map['original'] as String,
      lastSpoken:
          (map.containsKey('utterred')) ? map['utterred'] as String : '',
      attempts: (map.containsKey('attempts')) ? map['attempts'] as int : 0,
      succeeded:
          (map.containsKey('succeeded')) ? map['succeeded'] as bool : false,
      giveup: (map.containsKey('giveup')) ? map['giveup'] as bool : false,
      isReported:
          (map.containsKey('isReported')) ? map['isReported'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Word.fromJson(String source) =>
      Word.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Word other) {
    if (identical(this, other)) return true;

    return other.original == original &&
        other.lastSpoken == lastSpoken &&
        other.attempts == attempts &&
        other.succeeded == succeeded;
  }

  @override
  int get hashCode {
    return original.hashCode ^
        lastSpoken.hashCode ^
        attempts.hashCode ^
        succeeded.hashCode;
  }

  @override
  String toString() {
    return 'Word(original: $original, '
        'utterred: $lastSpoken, attempts: $attempts,'
        ' succeeded: $succeeded, giveup: $giveup)';
  }
}
