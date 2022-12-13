import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';
import '../../custom_widgets/menu2.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final Function() onClose;
  const TopMenu({super.key, required this.onClose, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Menu2(
      height: size.height,
      children: [
        CustomMenuButton(
          menuItem: CustomMenuItem(
            alignment: Alignment.centerLeft,
            icon: Icons.arrow_back,
            onTap: onClose,
          ),
        ),
        Hero(
          tag: "Start",
          child: Text(
            'Select One',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ],
    );
  }
}
