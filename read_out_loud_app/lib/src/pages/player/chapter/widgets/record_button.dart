import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:read_out_loud_app/src/custom_widgets/custom_menu.dart';
import 'package:read_out_loud_app/src/tts/stt_record.dart';

import '../providers/state_provider.dart';

class RecordButton extends ConsumerStatefulWidget {
  final Size size;
  final bool succeeded;
  const RecordButton({Key? key, required this.succeeded, required this.size})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecordButtonState();
}

class _RecordButtonState extends ConsumerState<RecordButton> {
  late Timer timer;
  @override
  Widget build(BuildContext context) {
    Size size = widget.size;
    final sttRecord = ref.watch(sttRecordProvider);
    final playState = ref.watch(playWordStateProvider);
    double square = max(50, min(size.width, size.height));
    return Center(
      child: SizedBox(
        width: square,
        height: square,
        child: Stack(
          children: [
            if (playState == PlayState.listening)
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(square / 2),
                    border: Border.all(),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: .26,
                          spreadRadius: sttRecord.level * 2,
                          color: Colors.red.withOpacity(.1)),
                      BoxShadow(
                          blurRadius: .26,
                          spreadRadius: sttRecord.level * 1.5,
                          color: Colors.blue.withOpacity(.1))
                      //max(1.0, sttRecord.level)*,
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(square * 0.05),
                    child: FittedBox(
                      child: CustomMenuButton(
                          menuItem: CustomMenuItem(
                              icon: Icons.mic,
                              title: widget.succeeded
                                  ? "Try again? "
                                  : "Tap to Speak",
                              onTap: () {})),
                    ),
                  ),
                ),
              )
            else ...[
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(square / 2),
                    border: Border.all(),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: .26, color: Colors.blue.withOpacity(.1))
                      //max(1.0, sttRecord.level)*,
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(square * 0.05),
                    child: FittedBox(
                      child: CustomMenuButton(
                          menuItem: CustomMenuItem(
                              icon: Icons.mic,
                              title: widget.succeeded
                                  ? "Try again? "
                                  : "Tap to Speak",
                              onTap: (PlayState.idle != playState)
                                  ? null
                                  : () {
                                      if (!kIsWeb &&
                                          (Platform.isAndroid ||
                                              Platform.isIOS)) {
                                        timer = Timer(
                                            const Duration(seconds: 3), () {
                                          ref
                                              .read(playWordStateProvider
                                                  .notifier)
                                              .sttStop();
                                        });
                                        ref
                                            .read(
                                                playWordStateProvider.notifier)
                                            .sttListen();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar((const SnackBar(
                                          content: Text(
                                              "This platform don't support Speech to Text"),
                                        )));
                                      }
                                    })),
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset((-size.height / 2) - 8, 0),
                child: Center(
                  child: SizedBox.fromSize(
                    size: Size(size.height, size.height),
                    child: FittedBox(
                      child: Lottie.asset(
                          "assets/Lotties/42193-hand-pointing-icon.json"),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
