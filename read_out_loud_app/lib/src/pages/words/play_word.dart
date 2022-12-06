import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../tts/tts_speaker.dart';
import 'main_word.dart';

enum PlayState { asking, listening, idle, done, reading }

class PlayWord extends ConsumerStatefulWidget {
  final Word word;
  final Size size;
  const PlayWord({super.key, required this.word, required this.size});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayWordState();
}

class _PlayWordState extends ConsumerState<PlayWord> {
  late PlayState playState;

  @override
  void initState() {
    playState = PlayState.idle;

    WidgetsBinding.instance.addPostFrameCallback((_) => speak());
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  speak() async {
    if (playState != PlayState.idle) return;
    setState(() {
      playState = PlayState.asking;
    });

    await ref
        .read(ttsSpeakerProvider.notifier)
        .play("Can you read this word for me?", onComplete: () async {
      if (mounted) {
        setState(() {
          playState = PlayState.idle;
        });

        listen();
      } else {
        return;
      }
    }, onCancel: () {
      if (mounted) {
        setState(() {
          playState = PlayState.idle;
        });
      } else {}
    });
  }

  listen() async {
    if (playState != PlayState.idle) return;
    if (mounted) {
      setState(() {
        playState = PlayState.listening;
      });
    }
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      setState(() {
        playState = PlayState.idle;
      });
    }
  }

  done() async {
    setState(() {
      playState = PlayState.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final TTSSpeaker speaker = ref.watch(ttsSpeakerProvider);
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
              onTap: (playState != PlayState.idle)
                  ? null
                  : () {
                      setState(() {
                        playState = PlayState.reading;
                      });
                      ref
                          .watch(ttsSpeakerProvider.notifier)
                          .play(widget.word.original, onCancel: () {
                        setState(() {
                          playState = PlayState.idle;
                        });
                      }, onComplete: () {
                        setState(() {
                          playState = PlayState.idle;
                        });
                      });
                    },
            ),
          ),
        ),
        Positioned(bottom: 40, left: 0, right: 0, child: showState())
      ],
    );
  }

  showState() {
    switch (playState) {
      case PlayState.reading:
        return Container();

      case PlayState.idle:
        return GestureDetector(
          onTap: () {
            listen();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.mic_rounded,
                size: 100,
                color: Colors.blue,
              ),
              Text("Try again ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))
            ],
          ),
        );

      case PlayState.asking:
        return const Text(
          "Can you read this word? ",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
        );
      case PlayState.listening:
        return Text(
          "Listening...",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.red.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 40),
        );

      case PlayState.done:
        return const Icon(
          Icons.done,
          size: 100,
        );
    }
  }

  speakWork() {}
}

class PlayerStateNotifier extends StateNotifier<PlayState> {
  PlayerStateNotifier() : super(PlayState.idle);

  updateState(PlayState playState) {
    state = playState;
  }
}

final playerStateProvider =
    StateNotifierProvider<PlayerStateNotifier, PlayState>((ref) {
  return PlayerStateNotifier();
});
