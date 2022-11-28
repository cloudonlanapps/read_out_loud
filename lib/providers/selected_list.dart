import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedListNotifier extends StateNotifier<String> {
  SelectedListNotifier() : super("");

  newAsset(String assetName) {
    state = assetName;
  }
}

final selectedListProvider =
    StateNotifierProvider<SelectedListNotifier, String>((ref) {
  return SelectedListNotifier();
});
