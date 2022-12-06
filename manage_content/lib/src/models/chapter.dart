import 'dart:convert';
import 'dart:math';

class Chapter {
  final String title;
  final String filename;
  late final double percentageCompleted;
  Chapter({
    required this.title,
    required this.filename,
  }) {
    var rng = Random();
    percentageCompleted = rng.nextDouble();
  }

  Chapter copyWith({
    String? title,
    String? filename,
    int? index,
  }) {
    return Chapter(
      title: title ?? this.title,
      filename: filename ?? this.filename,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'filename': filename,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      title: map['title'] as String,
      filename: map['filename'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Item(title: $title, filename: $filename)';

  @override
  bool operator ==(covariant Chapter other) {
    if (identical(this, other)) return true;

    return other.title == title && other.filename == filename;
  }

  @override
  int get hashCode => title.hashCode ^ filename.hashCode;
}
