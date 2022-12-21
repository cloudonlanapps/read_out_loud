import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:read_out_loud_app/src/tts/stt_record.dart';

import '../../../../custom_widgets/sizedbox_decorated.dart';
import '../providers/state_provider.dart';
import 'intro_widget.dart';
import 'main_word.dart';
import 'record_button.dart';
import 'score.dart';
import 'stt_result.dart';

class PlayWord extends ConsumerStatefulWidget {
  const PlayWord({
    required this.word,
    required this.size,
    required this.words,
    required this.contentListConfig,
    super.key,
  });
  final ContentListConfig contentListConfig;
  final Word word;
  final Size size;
  final Words words;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayWordState();
}

class _PlayWordState extends ConsumerState<PlayWord> {
  final String introText = 'Can you read this word for me?';
  @override
  void initState() {
    ref.read(playWordStateProvider.notifier).currState = PlayState.idle;
    if (!widget.word.succeeded && ref.read(introEnableProvider)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => speak());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playState = ref.watch(playWordStateProvider);
    listener();
    final part = widget.size.height / 13;
    if (part < 35) {
      return const Center(child: Text('Too small screen to play'));
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
                SizedBoxDecorated(
                  height: part * 2,
                  child: Align(
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Score(words: widget.words),
                    ),
                  ),
                ),
                SizedBoxDecorated(
                  height: part * 4,
                ),
                Container(
                  height: part * 2,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                          child: Text(widget.word.attempts.toString()),
                        )
                    ],
                  ),
                ),
                if (playState == PlayState.intro)
                  SizedBoxDecorated(
                    height: part * 4,
                    width: widget.size.width,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: IntroWidget(introText: introText),
                    ),
                  )
                else ...[
                  SizedBoxDecorated(
                    height: part * 2,
                    width: widget.size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: STTResult(
                        highlight: widget.word.original,
                      ),
                    ),
                  ),
                  SizedBoxDecorated(
                    height: part * 2,
                    width: widget.size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: RecordButton(
                        succeeded: widget.word.succeeded,
                        size: Size(widget.size.width, part * 2),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> speak() => ref
      .read(playWordStateProvider.notifier)
      .speak(text: introText, playState: PlayState.intro);

  void listener() {
    ref.listen(sttRecordProvider, (prev, curr) {
      if (curr.lastStatus != prev?.lastStatus) {
        // print("Listener: status changed to ${curr.lastStatus}");
        if (['doneNoResult', 'done'].contains(curr.lastStatus)) {
          ref.read(sttRecordProvider.notifier).stopListening();
          ref.read(playWordStateProvider.notifier).currState = PlayState.idle;
          if (curr.lastWords.isNotEmpty) {
            final textBlocks =
                curr.lastWords.toLowerCase().highlight(widget.word.original);
            final succeeded = ref
                    .read(wordsProvider(widget.contentListConfig.filename))
                    ?.currentWord
                    ?.succeeded ??
                false;

            if (textBlocks.length == 3) {
              // Found the word.

              ref
                  .read(
                    wordsProvider(widget.contentListConfig.filename).notifier,
                  )
                  .success(widget.word);
              ref.read(playWordStateProvider.notifier).speak(text: 'Well Done');
            } else if (!succeeded) {
              ref
                  .read(
                    wordsProvider(widget.contentListConfig.filename).notifier,
                  )
                  .attempted(widget.word);
              ref.read(playWordStateProvider.notifier).speak(text: 'Try again');
            } else {
              ref.read(playWordStateProvider.notifier).speak(text: 'Try again');
            }
          }
          //ref.read(ttsSpeakerProvider.notifier).unmute();
          // Done, to clear level

        }
        if (['listening'].contains(curr.lastStatus)) {
          //ref.read(ttsSpeakerProvider.notifier).mute();
          ref.read(playWordStateProvider.notifier).currState =
              PlayState.listening;
        }
      }
    });
  }
}
