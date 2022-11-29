import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/word.dart';

class UtterredWord extends ConsumerWidget {
  final Word word;
  const UtterredWord({super.key, required this.word});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        if (word.utterred != '')
          if (word.succeeded)
            Text(
              "Well Done",
              style: TextStyle(color: Colors.greenAccent.shade400),
            )
          else ...[
            const Text("Did you say:"),
            Text(
              word.utterred,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.redAccent.shade400),
            )
          ],
      ],
    );
  }
}
