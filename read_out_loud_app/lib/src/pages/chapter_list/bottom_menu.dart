import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../custom_widgets/custom_menu.dart';
import 'providers/animate_state.dart';
import 'providers/paginate.dart';
import 'providers/state_provider.dart';

class BottomMenu extends ConsumerWidget {
  const BottomMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ListPaginate<Chapter> listProvider = ref.watch(contentPageProvider);
    final bool isAnimating = ref.watch(isAnimatingProvider);

    if (listProvider.numPages == 0) return Container();
    return CustomMenu(menuItems: [
      (listProvider.isFirst || isAnimating)
          ? null
          : CustomMenuItem(
              alignment: Alignment.bottomCenter,
              icon: Icons.arrow_circle_left,
              onTap: () async {
                await ref.read(contentPageProvider.notifier).prev();
              },
              title: 'Prev'),
      CustomMenuItem(
          alignment: Alignment.bottomCenter,
          icon: Icons.density_medium,
          onTap: () {},
          title: "${listProvider.currentPage + 1}/${listProvider.numPages}"),
      (listProvider.isLast || isAnimating)
          ? null
          : CustomMenuItem(
              alignment: Alignment.bottomCenter,
              icon: Icons.arrow_circle_right,
              onTap: () async {
                await ref.read(contentPageProvider.notifier).next();
              },
              title: 'Next')
    ]);
  }
}
