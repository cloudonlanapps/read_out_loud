import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsAnimatingNotifier extends StateNotifier<bool> {
  IsAnimatingNotifier() : super(false);

  set isAnimating(bool val) {
    state = val;
  }
}

final isAnimatingProvider =
    StateNotifierProvider<IsAnimatingNotifier, bool>((ref) {
  return IsAnimatingNotifier();
});
