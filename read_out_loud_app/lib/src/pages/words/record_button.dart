import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:read_out_loud_app/src/tts/stt_record.dart';

import 'state_provider.dart';

class RecordButton extends ConsumerWidget {
  const RecordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sttRecord = ref.watch(sttRecordProvider);
    final playState = ref.watch(playWordStateProvider);
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
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
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: IconButton(
                        icon: const Icon(Icons.mic),
                        onPressed: () {
                          ref.read(playWordStateProvider.notifier).sttListen();
                        }),
                  ),
                  const SizedBox(
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
                      child: SizedBox(
                        //margin: const EdgeInsets.all(4.0),
                        width: 40,
                        height: 40,
                        //color: Colors.blue,
                        child: Lottie.asset(
                            "assets/42193-hand-pointing-icon.json"),
                      ),
                    ),
                    const SizedBox(
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
              : const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Tap to Speak",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        )
      ],
    );
  }
}
