import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';
import 'providers/animate_state.dart';
import 'providers/state_provider.dart';

class BottomMenu extends ConsumerWidget {
  final Size size;
  final ContentListConfig contentListConfig;
  const BottomMenu(
      {super.key, required this.contentListConfig, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<ContentListState> asyncValue =
        ref.watch(contentListStateProvider(contentListConfig));
    final bool isAnimating = ref.watch(isAnimatingProvider);
    return asyncValue.when(
        data: (ContentListState currState) {
          if (currState.numPages == 0) return Container();
          return CustomMenu(menuItems: [
            (currState.isFirst || isAnimating)
                ? null
                : CustomMenuItem(
                    alignment: Alignment.bottomCenter,
                    icon: Icons.arrow_circle_left,
                    onTap: () async {
                      await ref
                          .read(contentListStateProvider(contentListConfig)
                              .notifier)
                          .prev(currState);
                    },
                    title: 'Prev'),
            CustomMenuItem(
                alignment: Alignment.bottomCenter,
                icon: Icons.density_medium,
                onTap: () {},
                title: "${currState.currentPage + 1}/${currState.numPages}"),
            (currState.isLast || isAnimating)
                ? null
                : CustomMenuItem(
                    alignment: Alignment.bottomCenter,
                    icon: Icons.arrow_circle_right,
                    onTap: () async {
                      await ref
                          .read(contentListStateProvider(contentListConfig)
                              .notifier)
                          .next(currState);
                    },
                    title: 'Next')
          ]);
        },
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator());
  }
}
