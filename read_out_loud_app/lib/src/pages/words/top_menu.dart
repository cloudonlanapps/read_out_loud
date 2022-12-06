import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final Function() onSettings;
  const TopMenu({super.key, required this.onSettings, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomMenu(menuItems: [
      CustomMenuItem(
        alignment: Alignment.centerRight,
        icon: Icons.home,
        onTap: onSettings,
      ),
    ]);
  }
}
