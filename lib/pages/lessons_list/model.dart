import 'package:manage_content/manage_content.dart';

import '../../shared/models/item_list.dart';

class LessonsList extends ItemList<Chapter> {
  LessonsList({
    required List<Chapter> items,
    int itemsPerPage = 5,
    int currentPage = 0,
  }) : super(
            items: items,
            itemsPerPage: itemsPerPage,
            currentPage: currentPage,
            numPages: (items.length + itemsPerPage - 1) ~/ itemsPerPage) {
    if (items.isEmpty) {
      //   throw Exception("No lessons found");
    }
    if (numPages > 0) {
      if (currentPage < 0 || currentPage >= numPages) {
        throw Exception("Invalid value for currentPage");
      }
    }
  }

  LessonsList copyWith({
    List<Chapter>? items,
    int? itemsPerPage,
    int? currentPage,
  }) {
    return LessonsList(
      items: items ?? this.items,
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
