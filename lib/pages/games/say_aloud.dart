// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud/pages/games/widgets/bottom_menu.dart';

import 'widgets/main_word.dart';
import 'widgets/utterred_word.dart';

class SayAloud extends ConsumerStatefulWidget {
  const SayAloud({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SayAloudState();
}

class SayAloudState extends ConsumerState<SayAloud> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 55, height: 1, color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: const [
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "Can you read this word?",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: MainWord(),
            ),
          ),
          Flexible(
            child: UtterredWord(),
          ),
          Flexible(
            child: SizedBox(
              height: 32,
            ),
          ),
          BottomMenu()
        ],
      ),
    );
  }
}

//Unused
class Interact extends ConsumerWidget {
  final String utteredWord;
  const Interact({super.key, required this.utteredWord});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        height: 200,
        width: double.infinity,
        color: (utteredWord == '')
            ? Colors.amberAccent.shade400
            : (utteredWord.toLowerCase() == 'water')
                ? Colors.greenAccent.shade400
                : Colors.redAccent.shade400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (utteredWord != '') ...[
              const Text("You said:"),
              Text(
                "You said: $utteredWord",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 55,
                  height: 1,
                ),
              )
            ] else
              const Text(
                "Can you read this word?",
                style: TextStyle(
                  fontSize: 55,
                  letterSpacing: 1.5,
                  height: 1,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
          ],
        ),
      ),
    );
  }
}
