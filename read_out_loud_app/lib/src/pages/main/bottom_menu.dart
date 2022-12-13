import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud_app/src/custom_widgets/sizedbox_decorated.dart';

import '../../custom_widgets/custom_menu.dart';

class BottomMenu extends ConsumerWidget {
  final Size size;
  final Function() onPlay;
  const BottomMenu({super.key, required this.onPlay, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double verticalPad = size.height > 80 ? (size.height - 65) / 2 : 0;
    return Transform.translate(
      offset: const Offset(0, -32),
      child: Transform.scale(
        scale: 1.0,
        child: InkWell(
          onTap: onPlay,
          child: SizedBoxDecorated.fromSize(
            size: size,
            //debug: true,
            child: DottedBorder(
              padding: EdgeInsets.symmetric(
                  vertical: verticalPad + 8.0, horizontal: 8.0),
              child: Expanded(
                child: CustomMenu(
                  menuItems: [
                    null,
                    CustomMenuItem(
                        color: Colors.black,
                        //icon: Icons.play_circle_filled_outlined,
                        //onTap: onPlay,
                        title: "Play"),
                    null,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
