import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'audio_player.dart';

class MainContent extends ConsumerWidget {
  const MainContent({
    required this.filename,
    required this.size,
    super.key,
  });
  final Size size;
  final String? filename;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const AudioPlayer();
  }
}
