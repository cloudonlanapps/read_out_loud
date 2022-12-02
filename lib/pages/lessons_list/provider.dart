import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/size_provider.dart';
import 'model.dart';
import 'repo.dart';

class LessonsListNotifier extends StateNotifier<LessonsList?> {
  LessonsListNotifier(LessonsList? lessonsList) : super(lessonsList);

  prev() => state = state?.prev();

  next() => state = state?.next();
}

final lessonsListProvider =
    StateNotifierProvider<LessonsListNotifier, LessonsList?>((ref) {
  final itemsPerPage =
      ref.watch(sizeProvider.select((value) => value.tileCount));

  return LessonsListNotifier(
      LessonsList(lessons: lessonsListRepo, itemsPerPage: itemsPerPage));
});
