import 'dart:math' show min;

abstract class ItemList<T> {
  final List<T> items;
  final int itemsPerPage; // Can this be modified by screen size?
  final int currentPage;
  late int numPages;
  ItemList({
    required this.items,
    required this.itemsPerPage,
    required this.currentPage,
    required this.numPages,
  });

  ItemList<T> prev();
  ItemList<T> next();

  bool get isFirst => currentPage == 0;
  bool get isLast => currentPage == (numPages - 1);

  List<T> getcurrentPage() {
    return items.sublist(currentPage * itemsPerPage,
        min(items.length, (currentPage + 1) * itemsPerPage));
  }
}
