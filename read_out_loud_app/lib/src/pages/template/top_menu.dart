import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';

class TopMenu extends ConsumerWidget {
  const TopMenu({
    required this.onSettings,
    required this.size,
    super.key,
  });
  final Size size;
  final Function() onSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomMenu(
      menuItems: [
        CustomMenuItem(
          alignment: Alignment.centerRight,
          icon: Icons.home,
          onTap: onSettings,
        ),
      ],
    );
  }
}
