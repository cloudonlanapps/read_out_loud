import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/chapter_list_view.dart';
import 'providers/state_provider.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final ContentListConfig contentListConfig;
  const MainContent(
      {super.key, required this.contentListConfig, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<ContentListState> asyncValue =
        ref.watch(contentListStateProvider(contentListConfig));
    return asyncValue.when(
        data: (ContentListState currState) {
          if (currState.repository.isEmpty) {
            return const Center(
              child: Text(
                "Nothing to show here",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Horizon',
                ),
              ),
            );
          }
          final currPage = currState.getcurrentPage();
          return ChapterListView(
              key: ObjectKey(currPage),
              repository: currState.repository,
              items: currPage,
              size: Size(size.width, size.height));
        },
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator());
  }
}
