import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentLesson = StateProvider<String?>((ref) {
  return null;
});

final lessonsProvider = StateProvider<List<String>>((ref) {
  return [
    "wordlist1",
    "wordlist2",
    "wordlist3",
  ];
});
