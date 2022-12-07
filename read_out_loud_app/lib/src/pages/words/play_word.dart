import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:read_out_loud_app/src/tts/stt_record.dart';

import 'intro_widget.dart';
import 'main_word.dart';
import 'record_button.dart';
import 'state_provider.dart';
import 'stt_result.dart';

class PlayWord extends ConsumerStatefulWidget {
  final Word word;
  final Size size;
  const PlayWord({super.key, required this.word, required this.size});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayWordState();
}

class _PlayWordState extends ConsumerState<PlayWord> {
  final String introText = "Can you read this word for me?";
  @override
  void initState() {
    ref.read(playWordStateProvider.notifier).newState = PlayState.idle;
    WidgetsBinding.instance.addPostFrameCallback((_) => speak());
    super.initState();
  }

  speak() => ref
      .read(playWordStateProvider.notifier)
      .speak(text: introText, playState: PlayState.intro);

  listener() {
    ref.listen(sttRecordProvider, (STTRecord? prev, STTRecord curr) {
      if (curr.lastStatus != prev?.lastStatus) {
        // print("Listener: status changed to ${curr.lastStatus}");
        if (["doneNoResult", "done"].contains(curr.lastStatus)) {
          //ref.read(ttsSpeakerProvider.notifier).unmute();
          // Done, to clear level
          ref.read(sttRecordProvider.notifier).stopListening();
          ref.read(playWordStateProvider.notifier).newState = PlayState.idle;
        }
        if (["listening"].contains(curr.lastStatus)) {
          //ref.read(ttsSpeakerProvider.notifier).mute();
          ref.read(playWordStateProvider.notifier).newState =
              PlayState.listening;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final playState = ref.watch(playWordStateProvider);
    listener();
    return Stack(
      children: [
        SizedBox.fromSize(
          size: widget.size,
        ),
        Center(
          child: Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MainWord(
              word: widget.word.original,
              onTap: () => ref
                  .read(playWordStateProvider.notifier)
                  .speak(text: widget.word.original),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: DecoratedBox(
            decoration: const BoxDecoration(),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                if (playState == PlayState.intro)
                  SizedBox(
                    height: 200,
                    width: widget.size.width,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: IntroWidget(introText: introText)),
                  )
                else ...[
                  SizedBox(
                      height: 100,
                      width: widget.size.width,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: STTResult(),
                      )),
                  SizedBox(
                      height: 100,
                      width: widget.size.width,
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: FittedBox(
                            fit: BoxFit.fitHeight, child: RecordButton()),
                      )),
                ]
              ],
            ),
          ),
        )
      ],
    );
  }
}
