import 'package:flutter_test/flutter_test.dart';
import 'package:read_out_loud_app/services/paginate.dart';

void main() {
  test('Testing Paginator', () {
    int totalCount = 22;
    int tileCount = 10;
    double tileHeight = 45;

    double height = (tileCount + 1.5) * tileHeight;

    final ListPaginate<int> paginator = ListPaginate<int>(
      width: 100,
      height: height,
      items: List.generate(totalCount, (index) => index),
    );

    expect([paginator.itemsPerPage, paginator.numPages, tileHeight],
        [tileCount, (totalCount + tileCount - 1) ~/ tileCount, tileHeight]);
  });
}
