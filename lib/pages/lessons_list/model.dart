import '../../shared/models/item_list.dart';

class LessonsList extends ItemList<String> {
  LessonsList({
    required List<String> lessons,
    int itemsPerPage = 5,
    int currentPage = 0,
  }) : super(
            lessons: lessons,
            itemsPerPage: itemsPerPage,
            currentPage: currentPage,
            numPages: (lessons.length + itemsPerPage - 1) ~/ itemsPerPage) {
    if (lessons.isEmpty) {
      //   throw Exception("No lessons found");
    }
    if (numPages > 0) {
      if (currentPage < 0 || currentPage >= numPages) {
        throw Exception("Invalid value for currentPage");
      }
    }
  }

  LessonsList copyWith({
    List<String>? lessons,
    int? itemsPerPage,
    int? currentPage,
  }) {
    return LessonsList(
      lessons: lessons ?? this.lessons,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  LessonsList prev() {
    if (isFirst) {
      return this;
    }
    return copyWith(currentPage: currentPage - 1);
  }

  @override
  LessonsList next() {
    if (isLast) {
      return this;
    }
    return copyWith(currentPage: currentPage + 1);
  }
}
