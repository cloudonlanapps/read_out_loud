import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SizeProperties {
  double tileHeight = 75;
  Size? size;
  int get tileCount =>
      ((size == null) ? 1 : (size!.height - 75.0) / tileHeight).toInt();

  double get titleHeight {
    final double h =
        (size == null) ? 0 : size!.height - (tileCount * tileHeight);

    return h;
  }

  SizeProperties(this.size);
}

class SizeNotifier extends StateNotifier<SizeProperties> {
  SizeNotifier(Size? size) : super(SizeProperties(size));

  set size(Size? size) {
    state = SizeProperties(size);
  }
}

final sizeProvider = StateNotifierProvider<SizeNotifier, SizeProperties>((ref) {
  return SizeNotifier(null);
});
