import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../custom_widgets/custom_menu.dart';

import 'providers/state_provider.dart';

class BottomMenu extends ConsumerWidget {
  const BottomMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listProvider = ref.watch(contentPageProvider);
    final isAnimating = ref.watch(isAnimatingProvider);

    if (listProvider.numPages == 0) {
      return Container();
    }
    return CustomMenu(
      menuItems: [
        if (listProvider.isFirst || isAnimating)
          null
        else
          CustomMenuItem(
            alignment: Alignment.bottomCenter,
            icon: Icons.arrow_circle_left,
            onTap: () async {
              ref.read(contentPageProvider.notifier).prev();
            },
            title: 'Prev',
          ),
        CustomMenuItem(
          alignment: Alignment.bottomCenter,
          icon: Icons.density_medium,
          onTap: () {},
          title: '${listProvider.currentPage + 1}/${listProvider.numPages}',
        ),
        if (listProvider.isLast || isAnimating)
          null
        else
          CustomMenuItem(
            alignment: Alignment.bottomCenter,
            icon: Icons.arrow_circle_right,
            onTap: () async {
              ref.read(contentPageProvider.notifier).next();
            },
            title: 'Next',
          )
      ],
    );
  }
}
