import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final Function() onClose;
  const TopMenu({super.key, required this.onClose, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomMenu(menuItems: [
      CustomMenuItem(
        color: Colors.black,
        alignment: Alignment.centerLeft,
        icon: Icons.arrow_back,
        onTap: onClose,
      ),
    ]);
  }
}
