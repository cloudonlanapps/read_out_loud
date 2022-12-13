import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:read_out_loud_app/src/tts/stt_record.dart';

import 'intro_widget.dart';
import 'main_word.dart';
import 'record_button.dart';
import 'score.dart';
import '../providers/state_provider.dart';
import 'stt_result.dart';

class PlayWord extends ConsumerStatefulWidget {
  final ContentListConfig contentListConfig;
  final Word word;
  final Size size;
  final Words words;
  const PlayWord(
      {super.key,
      required this.word,
      required this.size,
      required this.words,
      required this.contentListConfig});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayWordState();
}

class _PlayWordState extends ConsumerState<PlayWord> {
  final String introText = "Can you read this word for me?";
  @override
  void initState() {
    ref.read(playWordStateProvider.notifier).newState = PlayState.idle;
    if (!widget.word.succeeded) {
      WidgetsBinding.instance.addPostFrameCallback((_) => speak());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playState = ref.watch(playWordStateProvider);
    listener();
    double part = widget.size.height / 13;
    if (part < 35) {
      return const Center(child: Text("Too small screen to play"));
    }

    return Stack(
      children: [
        SizedBox.fromSize(
          size: widget.size,
          //child: Container(decoration: BoxDecoration(border: Border.all())),
        ),
        Positioned(
          bottom: part,
          left: 0,
          right: 0,
          child: DecoratedBox(
            decoration: const BoxDecoration(),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    height: part * 2,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Score(words: widget.words))),
                SizedBox(
                  height: part * 4,
                ),
                Container(
                  height: part * 2,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      MainWord(
                        word: widget.word,
                        onTap: () => ref
                            .read(playWordStateProvider.notifier)
                            .speak(text: widget.word.original),
                      ),
                      if (widget.word.attempts > 0)
                        Positioned(
                            right: 10,
                            top: 10,
                            child: Text(widget.word.attempts.toString()))
                    ],
                  ),
                ),
                if (playState == PlayState.intro)
                  SizedBox(
                    height: part * 4,
                    width: widget.size.width,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: IntroWidget(introText: introText)),
                  )
                else ...[
                  SizedBox(
                      height: part * 2,
                      width: widget.size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: STTResult(
                          highlight: widget.word.original,
                        ),
                      )),
                  SizedBox(
                      height: part * 2,
                      width: widget.size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child:
                                RecordButton(succeeded: widget.word.succeeded)),
                      )),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  speak() => ref
      .read(playWordStateProvider.notifier)
      .speak(text: introText, playState: PlayState.intro);

  listener() {
    ref.listen(sttRecordProvider, (STTRecord? prev, STTRecord curr) {
      if (curr.lastStatus != prev?.lastStatus) {
        // print("Listener: status changed to ${curr.lastStatus}");
        if (["doneNoResult", "done"].contains(curr.lastStatus)) {
          ref.read(sttRecordProvider.notifier).stopListening();
          ref.read(playWordStateProvider.notifier).newState = PlayState.idle;
          if (curr.lastWords.isNotEmpty) {
            List<String> textBlocks =
                curr.lastWords.toLowerCase().highlight(widget.word.original);
            bool succeeded = ref
                    .read(wordsProvider(widget.contentListConfig.filename))
                    ?.currentWord
                    ?.succeeded ??
                false;

            if (textBlocks.length == 3) {
              // Found the word.

              ref
                  .read(
                      wordsProvider(widget.contentListConfig.filename).notifier)
                  .success(widget.word);
              ref.read(playWordStateProvider.notifier).speak(text: 'Well Done');
            } else if (!succeeded) {
              ref
                  .read(
                      wordsProvider(widget.contentListConfig.filename).notifier)
                  .attempted(widget.word);
              ref.read(playWordStateProvider.notifier).speak(text: 'Try again');
            } else {
              ref.read(playWordStateProvider.notifier).speak(text: 'Try again');
            }
          }
          //ref.read(ttsSpeakerProvider.notifier).unmute();
          // Done, to clear level

        }
        if (["listening"].contains(curr.lastStatus)) {
          //ref.read(ttsSpeakerProvider.notifier).mute();
          ref.read(playWordStateProvider.notifier).newState =
              PlayState.listening;
        }
      }
    });
  }
}
