import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final String? filename;
  final Function() onPlay;
  const MainContent({
    super.key,
    required this.filename,
    required this.size,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    final colorizeTextStyle =
        Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 50);
    return Stack(
      children: [
        Positioned(
            top: 32,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () {},
              child: SizedBox(
                height: 100,
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
            )),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150),
              child: GestureDetector(
                  onTap: onPlay,
                  child: Lottie.asset("assets/16853-play-button.json")),
            )),
      ],
    );
  }
}
/**
 * 
 * 
 * Text(
        'Ready to Play?',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
 return SizedBox(
  width: 250.0,
  child: TextLiquidFill(
    text: 'LIQUIDY',
    waveColor: Colors.blueAccent,
    boxBackgroundColor: Colors.redAccent,
    textStyle: TextStyle(
      fontSize: 80.0,
      fontWeight: FontWeight.bold,
    ),
    boxHeight: 300.0,
  ),
);

 */