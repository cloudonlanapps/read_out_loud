import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainWord extends ConsumerWidget {
  const MainWord({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      // TODO: TTS
      child: DottedBorder(
          //dashPattern: const [6, 3, 2, 3],
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(),
              ),
              width: double.infinity,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 32),
                child: Text(
                  "Water",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                ),
              ))),
    );
  }
}
