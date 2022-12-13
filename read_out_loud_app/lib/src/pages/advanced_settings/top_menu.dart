import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';
import '../../custom_widgets/menu3.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final Function() onClose;
  const TopMenu({super.key, required this.onClose, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Menu3(
      height: 65,
      children: [
        CustomMenuButton(
          menuItem: CustomMenuItem(
            alignment: Alignment.centerRight,
            icon: Icons.arrow_back,
            onTap: onClose,
          ),
        ),
        Center(
          child: Text(
            "Advanced",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        null
      ],
    );
  }
}
