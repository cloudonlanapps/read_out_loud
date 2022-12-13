import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';
import '../../custom_widgets/menu3.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final Function() onSettings;
  const TopMenu({super.key, required this.onSettings, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Menu3(height: size.height, children: [
      null,
      null,
      Center(
        child: CustomMenuButton(
            menuItem: CustomMenuItem(
                icon: Icons.settings, onTap: onSettings, title: "Settings")),
      ),
    ]);
  }
}
