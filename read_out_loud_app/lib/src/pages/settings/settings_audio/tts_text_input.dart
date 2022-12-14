import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TTSTextInput extends ConsumerWidget {
  final TextEditingController controller;
  const TTSTextInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        alignment: Alignment.topCenter,
        child: TextField(
          enabled: false,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), label: Text("edit")),
          controller: controller,
          maxLines: 3,
          minLines: 1,
        ));
  }
}
