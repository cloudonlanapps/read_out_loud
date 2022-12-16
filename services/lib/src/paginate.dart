// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

class ListPaginate<T> {
  final List<T> items;

  final double height;
  final double width;

  final int currentPage;
  late final int _itemsPerPage;
  late final double _tileSize;
  late final int _numPages;

  int get itemsPerPage => _itemsPerPage;
  int get numPages => _numPages;
  double get tileWidth => width;
  double get titleWidth => width;
  double get tileHeight => _tileSize;
  double get titleHeight => height - (_tileSize * itemsPerPage);

  double? minTileSize;
  double? maxTileSize;

  ListPaginate(
      {required this.items,
      required this.width,
      required this.height,
      this.currentPage = 0,
      int? itemsPerPage,
      double? tileSize,
      this.minTileSize,
      this.maxTileSize}) {
    if (itemsPerPage != null && itemsPerPage <= 0) {
      throw Exception(
          "if provided, itemsPerPage must be null or greater than zero");
    }
    if (itemsPerPage != null) {
      _itemsPerPage = itemsPerPage;
      if (tileSize == null) {
        throw Exception(
            "when providng itemsPerPage, tileSize should also be provided");
      }
      _tileSize = tileSize;
    } else {
      double tileSizeLocal;
      int itemsPerPageLocal = 0;
      double minTileSize = this.minTileSize ?? 55;
      double maxTileSize = max(this.maxTileSize ?? this.minTileSize ?? 55,
          (height ~/ 60 * 5).toDouble());

      for (tileSizeLocal = maxTileSize;
          tileSizeLocal > minTileSize - 1;
          tileSizeLocal -= 5) {
        final count = height ~/ tileSizeLocal;
        if (count > 2) {
          itemsPerPageLocal = count;
          break;
        }
      }

      _itemsPerPage = itemsPerPageLocal;

      _tileSize = tileSizeLocal;
    }
    if (_itemsPerPage > 0) {
      _numPages = (items.length + _itemsPerPage - 1) ~/ _itemsPerPage;
    } else {
      _numPages = 0;
    }
  }

  List<T> getcurrentPage() {
    int pageNum = currentPage;
    return items.sublist(pageNum * itemsPerPage,
        min(items.length, (pageNum + 1) * itemsPerPage));
  }

  ListPaginate<T> copyWith({
    int? currentPage,
  }) {
    return ListPaginate<T>(
        items: items,
        width: width,
        height: height,
        currentPage: currentPage ?? this.currentPage,
        itemsPerPage: _itemsPerPage,
        tileSize: _tileSize);
  }

  bool get isFirst => currentPage == 0;
  bool get isLast => currentPage == (numPages - 1);

  ListPaginate<T> prev() {
    if (isFirst) {
      return this;
    }
    return copyWith(currentPage: currentPage - 1);
  }

  ListPaginate<T> next() {
    if (isLast) {
      return this;
    }
    return copyWith(currentPage: currentPage + 1);
  }

  bool get isEmpty => items.isEmpty;

  @override
  String toString() {
    return 'ListPaginate(items: $items, '
        'height: $height, width: $width,'
        ' currentPage: $currentPage, _itemsPerPage: $_itemsPerPage,'
        ' _tileSize: $_tileSize, _numPages: $_numPages)';
  }
}
