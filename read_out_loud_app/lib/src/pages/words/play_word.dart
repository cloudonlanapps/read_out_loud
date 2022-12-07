import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:read_out_loud_app/src/tts/stt_record.dart';

import 'intro_widget.dart';
import 'main_word.dart';
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
            decoration: BoxDecoration(border: Border.all()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (playState == PlayState.intro)
                  SizedBox(
                    height: 100,
                    width: widget.size.width,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: IntroWidget(introText: introText),
                    ),
                  )
                else
                  SizedBox(
                      height: 100,
                      width: widget.size.width,
                      child: const STTResult()),
                const TriggerSTT(),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TriggerSTT extends ConsumerWidget {
  const TriggerSTT({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sttRecord = ref.watch(sttRecordProvider);
    return SizedBox(
      height: 100,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .26,
                      spreadRadius: sttRecord.level * 1.5,
                      color: Colors.amber.withOpacity(.05))
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
          ),
        ],
      ),
    );
  }
}
