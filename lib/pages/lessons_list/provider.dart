import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model.dart';
import 'repo.dart';

class LessonsListNotifier extends StateNotifier<LessonsList?> {
  LessonsListNotifier(LessonsList? lessonsList) : super(lessonsList);
}

final lessonsListProvider =
    StateNotifierProvider<LessonsListNotifier, LessonsList?>((ref) {
  return LessonsListNotifier(LessonsList(lessons: lessonsListRepo));
});
