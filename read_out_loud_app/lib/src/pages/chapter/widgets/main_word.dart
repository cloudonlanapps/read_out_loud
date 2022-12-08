import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../../custom_widgets/blink.dart';

//import 'state_provider.dart';

class MainWord extends ConsumerWidget {
  final Word word;
  final Function()? onTap;
  const MainWord({super.key, required this.word, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final playState = ref.watch(playWordStateProvider);
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: DottedBorder(
              //dashPattern: const [6, 3, 2, 3],
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: Container(
                  decoration: BoxDecoration(
                    color: word.succeeded
                        ? Colors.amberAccent.shade100
                        : Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: FittedBox(
                      child: Text(
                        word.original,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: word.succeeded
                                ? const Color.fromARGB(255, 39, 242, 46)
                                : Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
        ),
        if (word.succeeded)
          Positioned(
              top: 0,
              bottom: 0,
              right: 40,
              child: Blink(
                blinkDuration: const Duration(seconds: 1),
                child: Transform.translate(
                  offset: const Offset(30, 0),
                  child: const Icon(
                    Icons.done,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
              ))
        /* if (playState == PlayState.idle)
          Transform.translate(
              offset: const Offset(0, 90),
              child: Center(
                  child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: Transform.rotate(
                    angle: -pi / 2,
                    child:
                        Lottie.asset("assets/42193-hand-pointing-icon.json")),
              ))) */
      ],
    );
  }
}
