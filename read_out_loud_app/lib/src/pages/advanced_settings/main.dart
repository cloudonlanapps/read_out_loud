import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'audio_player.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final String? filename;
  const MainContent({super.key, required this.filename, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.fromSize(
      size: size,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin:
                        const EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: Text("AudioPlayer Settings",
                          style: Theme.of(context).textTheme.bodyLarge),
                      children: const [AudioPlayerConfig()],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
