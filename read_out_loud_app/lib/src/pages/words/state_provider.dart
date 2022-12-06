class ContentListConfig {
  final String filename;
  ContentListConfig({
    required this.filename,
  });

  @override
  bool operator ==(covariant ContentListConfig other) {
    if (identical(this, other)) return true;

    return other.filename == filename;
  }

  @override
  int get hashCode => filename.hashCode;
}
/* 
class WordsState {
  final ContentListConfig contentListConfig;

  final Words words;
} */
