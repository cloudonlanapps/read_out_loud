import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../custom_widgets/custom_menu.dart';
import 'state_provider.dart';

class BottomMenu extends ConsumerWidget {
  final Size size;
  final ContentListConfig contentListConfig;
  const BottomMenu(
      {super.key, required this.contentListConfig, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Words? words = ref.watch(wordsProvider(contentListConfig.filename));
    if (words == null) {
      return Container();
    }
    const bool isAnimating = false;
    return CustomMenu(menuItems: [
      (words.isFirst || isAnimating)
          ? null
          : CustomMenuItem(
              alignment: Alignment.bottomCenter,
              icon: Icons.arrow_circle_left,
              onTap: () async {
                await ref
                    .read(wordsProvider(contentListConfig.filename).notifier)
                    .prev();
              },
              title: 'Prev'),
      null,
      (words.isLast || isAnimating)
          ? null
          : CustomMenuItem(
              alignment: Alignment.bottomCenter,
              icon: Icons.arrow_circle_right,
              onTap: () async {
                await ref
                    .read(wordsProvider(contentListConfig.filename).notifier)
                    .next();
              },
              title: 'Next')
    ]);
  }
}
