import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final Function() onSettings;
  const TopMenu({super.key, required this.onSettings, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double verticalPad = size.height > 65 ? (size.height - 65) / 2 : 0;

    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: verticalPad + 8.0, horizontal: 8.0),
      child: CustomMenu(menuItems: [
        null,
        null,
        CustomMenuItem(
          color: Colors.black,
          alignment: Alignment.centerRight,
          icon: Icons.settings,
          onTap: onSettings,
        ),
      ]),
    );
  }
}
