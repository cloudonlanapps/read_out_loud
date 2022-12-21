import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class MainContent extends ConsumerWidget {
  const MainContent({
    required this.filename,
    required this.onPlay,
    super.key,
  });
  final String? filename;
  final Function() onPlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'Start',
            child: Text(
              'Ready to Play?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: InkWell(
              onTap: onPlay,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  'assets/Lotties/59928-press-start-button.json',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
