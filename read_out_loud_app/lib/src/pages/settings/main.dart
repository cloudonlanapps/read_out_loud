import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final String? filename;
  const MainContent({super.key, required this.filename, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text(
        'TODO: Settings here',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 55,
          height: 1,
        ),
      ),
    );
  }
}
