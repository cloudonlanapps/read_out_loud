// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

class ListPaginate<T> {
  final List<T> items;

  final double minTileSize;
  final double maxTileSize;

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

  ListPaginate(
      {required this.items,
      required this.width,
      required this.height,
      this.minTileSize = 50,
      this.maxTileSize = 75,
      this.currentPage = 0,
      int? itemsPerPage,
      double? tileSize}) {
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

      for (tileSizeLocal = maxTileSize;
          tileSizeLocal > minTileSize - 1;
          tileSizeLocal -= 5) {
        final count = ((height / tileSizeLocal) - 1).toInt();
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
    print(this);
    int pageNum = currentPage;
    return items.sublist(pageNum * itemsPerPage,
        min(items.length, (pageNum + 1) * itemsPerPage));
  }

  ListPaginate<T> copyWith({
    int? currentPage,
  }) {
    return ListPaginate<T>(
        items: items,
        minTileSize: minTileSize,
        maxTileSize: maxTileSize,
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
    return 'ListPaginate(items: $items, minTileSize: $minTileSize, maxTileSize: $maxTileSize, height: $height, width: $width, currentPage: $currentPage, _itemsPerPage: $_itemsPerPage, _tileSize: $_tileSize, _numPages: $_numPages)';
  }
}
