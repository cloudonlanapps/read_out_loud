// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Word {
  final String original;
  final String utterred;
  final int attempts;
  final bool succeeded;
  final bool giveup;
  Word(
      {required this.original,
      required this.utterred,
      required this.attempts,
      required this.succeeded,
      required this.giveup});

  Word copyWith({
    String? original,
    String? utterred,
    int? attempts,
    bool? succeeded,
    bool? giveup,
  }) {
    return Word(
        original: original ?? this.original,
        utterred: utterred ?? this.utterred,
        attempts: attempts ?? this.attempts,
        succeeded: succeeded ?? this.succeeded,
        giveup: giveup ?? this.giveup);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'original': original,
      'utterred': utterred,
      'attempts': attempts,
      'succeeded': succeeded,
      'giveup': giveup,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      original: map['original'] as String,
      utterred: (map.containsKey('utterred')) ? map['utterred'] as String : '',
      attempts: (map.containsKey('attempts')) ? map['attempts'] as int : 0,
      succeeded:
          (map.containsKey('succeeded')) ? map['succeeded'] as bool : false,
      giveup: (map.containsKey('giveup')) ? map['giveup'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Word.fromJson(String source) =>
      Word.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Word other) {
    if (identical(this, other)) return true;

    return other.original == original &&
        other.utterred == utterred &&
        other.attempts == attempts &&
        other.succeeded == succeeded;
  }

  @override
  int get hashCode {
    return original.hashCode ^
        utterred.hashCode ^
        attempts.hashCode ^
        succeeded.hashCode;
  }

  @override
  String toString() {
    return 'Word(original: $original, '
        'utterred: $utterred, attempts: $attempts,'
        ' succeeded: $succeeded, giveup: $giveup)';
  }
}
