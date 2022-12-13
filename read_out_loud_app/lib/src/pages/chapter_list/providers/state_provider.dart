// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../../../services/paginate.dart';

class ContentPageNotifier extends StateNotifier<ListPaginate<Chapter>> {
  ContentPageNotifier(ListPaginate<Chapter> contentPage) : super(contentPage);

  prev() => state = state.prev();

  next() => state = state.next();
}

final contentPageProvider =
    StateNotifierProvider<ContentPageNotifier, ListPaginate<Chapter>>((ref) {
  throw Exception("Override with appropriate value");
});

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
