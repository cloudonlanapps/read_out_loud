import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final Function() onClose;
  const TopMenu({super.key, required this.onClose, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        CustomMenuButton(
          menuItem: CustomMenuItem(
            alignment: Alignment.centerRight,
            icon: Icons.arrow_back,
            onTap: onClose,
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Chapters",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CustomMenuButton(
            menuItem: CustomMenuItem(
                alignment: Alignment.centerRight,
                icon: Icons.add,
                onTap: onClose,
                title: "Add New"),
          ),
        ),
      ],
    );
  }
}
