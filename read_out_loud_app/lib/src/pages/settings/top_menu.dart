import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final Function() onSettings;
  const TopMenu({super.key, required this.onSettings, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        CustomMenuButton(
          menuItem: CustomMenuItem(
            alignment: Alignment.centerRight,
            icon: Icons.arrow_back,
            onTap: onSettings,
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Settings",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
          ),
        ),
      ],
    );
  }
}
