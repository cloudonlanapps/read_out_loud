import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../models/word.dart';

class MainWord extends StatelessWidget {
  final Word word;
  final Function()? onTap;
  const MainWord({super.key, required this.word, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: FittedBox(
                  child: Text(
                    word.original,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  ),
                ),
              ))),
    );
  }
}
