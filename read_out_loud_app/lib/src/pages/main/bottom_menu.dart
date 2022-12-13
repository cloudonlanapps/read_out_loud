import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomMenu extends ConsumerWidget {
  final Size size;
  final Function() onPlay;
  const BottomMenu({super.key, required this.onPlay, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double verticalPad = size.height > 80 ? (size.height - 65) / 2 : 0;
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    final colorizeTextStyle = Theme.of(context).textTheme.bodyLarge!;
    return Transform.translate(
      offset: const Offset(0, -32),
      child: Transform.scale(
        scale: 1.0,
        child: InkWell(
          onTap: onPlay,
          child: DottedBorder(
            padding: EdgeInsets.symmetric(
                vertical: verticalPad + 8.0, horizontal: 8.0),
            child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Ready to Play?',
                    textAlign: TextAlign.center,
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                    speed: const Duration(milliseconds: 500),
                  ),
                ],
                //pause: const Duration(milliseconds: 200),
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
