import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:read_out_loud_app/src/tts/stt_record.dart';

import '../../../custom_widgets/sizedbox_decorated.dart';
import '../providers/state_provider.dart';

class RecordButton extends ConsumerWidget {
  final bool succeeded;
  const RecordButton({Key? key, required this.succeeded}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sttRecord = ref.watch(sttRecordProvider);
    final playState = ref.watch(playWordStateProvider);
    return Column(
      children: [
        SizedBoxDecorated(
          height: 40,
          child: Stack(
            children: [
              if ([PlayState.listening, PlayState.idle].contains(playState))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBoxDecorated(
                      width: 40,
                      height: 40,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: .26,
                              spreadRadius: sttRecord.level * 2,
                              color: Colors.grey)
                        ],
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: IconButton(
                          icon: const Icon(Icons.mic),
                          onPressed: () {
                            if (!kIsWeb &&
                                (Platform.isAndroid || Platform.isIOS)) {
                              ref
                                  .read(playWordStateProvider.notifier)
                                  .sttListen();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar((const SnackBar(
                                content: Text(
                                    "This platform don't support Speech to Text"),
                              )));
                            }
                          }),
                    ),
                    const SizedBoxDecorated(
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              if (playState == PlayState.idle)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Transform.translate(
                      offset: const Offset(8, 0),
                      child: SizedBoxDecorated(
                        //margin: const EdgeInsets.all(4.0),
                        width: 40,
                        height: 40,
                        //color: Colors.blue,
                        child: Lottie.asset(
                            "assets/42193-hand-pointing-icon.json"),
                      ),
                    ),
                    const SizedBoxDecorated(
                      width: 40,
                      height: 40,
                    ),
                    Container(
                      margin: const EdgeInsets.all(4.0),
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      //color: Colors.blue,
                    ),
                  ],
                ),
            ],
          ),
        ),
        Container(
          child: (playState != PlayState.idle)
              ? null
              : Align(
                  alignment: Alignment.center,
                  child: Text(
                    succeeded ? "Try again? " : "Tap to Speak",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
        )
      ],
    );
  }
}
