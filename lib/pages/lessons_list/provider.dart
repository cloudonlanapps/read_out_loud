import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../shared/providers/size_provider.dart';
import 'model.dart';

class LessonsListNotifier extends StateNotifier<LessonsList?> {
  LessonsListNotifier(LessonsList? lessonsList) : super(lessonsList);

  prev() => state = state?.prev();

  next() => state = state?.next();
}

final lessonsListProvider =
    StateNotifierProvider<LessonsListNotifier, LessonsList?>((ref) {
  final itemsPerPage =
      ref.watch(sizeProvider.select((value) => value.tileCount));
  print("itemsPerPage : $itemsPerPage");

  Repository repository = ref.watch(repositoryProvider);
  return LessonsListNotifier(
      LessonsList(items: repository.chapters, itemsPerPage: itemsPerPage));
});
