import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';
import '../../custom_widgets/menu3.dart';

class BottomMenu extends ConsumerWidget {
  final Size size;
  final Function() onPlay;
  const BottomMenu({super.key, required this.onPlay, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Menu3(
        height: size.height,
        children: [
          null,
          CustomMenuButton(
            menuItem: CustomMenuItem(
                icon: Icons.play_circle_filled_outlined,
                onTap: onPlay,
                title: "Play"),
          ),
          null
        ],
      ),
    );
  }
}
