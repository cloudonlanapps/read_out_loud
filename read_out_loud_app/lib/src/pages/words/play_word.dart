import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import 'main_word.dart';

enum PlayState { asking, listening, idle, done }

class PlayWord extends ConsumerStatefulWidget {
  final Word word;
  final Size size;
  const PlayWord({super.key, required this.word, required this.size});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayWordState();
}

class _PlayWordState extends ConsumerState<PlayWord> {
  PlayState playState = PlayState.idle;

  @override
  void initState() {
    actions();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  actions() async {
    Duration duration = const Duration(seconds: 2);
    playState = PlayState.asking;
    while (playState != PlayState.done) {
      if (!mounted) break;
      switch (playState) {
        case PlayState.idle:
          await Future.delayed(duration, () {
            if (mounted) {
              setState(() {
                playState = PlayState.asking;
              });
            }
          });
          break;
        case PlayState.asking:
          await Future.delayed(duration, () {
            if (mounted) {
              setState(() {
                playState = PlayState.listening;
              });
            }
          });
          break;
        case PlayState.listening:
          await Future.delayed(duration, () {
            if (mounted) {
              setState(() {
                playState = PlayState.idle;
              });
            }
          });
          break;
        case PlayState.done:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            ),
          ),
        ),
        Positioned(bottom: 40, left: 0, right: 0, child: showState())
      ],
    );
  }

  showState() {
    switch (playState) {
      case PlayState.idle:
        return const Icon(
          Icons.mic_rounded,
          size: 100,
          color: Colors.blue,
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
