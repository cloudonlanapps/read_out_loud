import 'package:flutter_test/flutter_test.dart';
import 'package:services/services.dart';

void main() {
  test('Testing Paginator', () {
    const totalCount = 22;
    const tileCount = 10;
    const tileHeight = 45;

    const height = (tileCount + 1.5) * tileHeight;

    final paginator = ListPaginate<int>(
      width: 100,
      height: height,
      items: List.generate(totalCount, (index) => index),
    );

    expect(
      [paginator.itemsPerPage, paginator.numPages, tileHeight],
      [tileCount, (totalCount + tileCount - 1) ~/ tileCount, tileHeight],
    );
  });
}
