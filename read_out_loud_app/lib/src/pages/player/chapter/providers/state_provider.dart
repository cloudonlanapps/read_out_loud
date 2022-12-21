import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud_app/src/tts/stt_record.dart';

import '../../../../tts/tts_speaker.dart';

enum PlayState { idle, intro, listening, reading }

@immutable
class ContentListConfig {
  const ContentListConfig({
    required this.filename,
  });
  final String filename;

  @override
  bool operator ==(covariant ContentListConfig other) {
    if (identical(this, other)) {
      return true;
    }

    return other.filename == filename;
  }

  @override
  int get hashCode => filename.hashCode;
}

class PlayWordStateNotifier extends StateNotifier<PlayState> {
  PlayWordStateNotifier(this.ref) : super(PlayState.idle);
  Ref ref;

  set currState(PlayState val) {
    // print("State changed to $val");
    state = val;
  }

  PlayState get currState => state;

  Future<void> speak({required String text, PlayState? playState}) async {
    if (state != PlayState.idle) {
      return;
    }
    ref.read(playWordStateProvider.notifier).currState =
        playState ?? PlayState.reading;
    await ref.read(ttsSpeakerProvider.notifier).play(
          text,
          onComplete: () => ref.read(playWordStateProvider.notifier).currState =
              PlayState.idle,
          onCancel: () => ref.read(playWordStateProvider.notifier).currState =
              PlayState.idle,
        );
  }

  Future<void> sttListen() async {
    if (state == PlayState.idle) {
      currState = PlayState.listening;
      //await ref.read(ttsSpeakerProvider.notifier).mute();
      await ref.read(sttRecordProvider.notifier).startListening();
    }
  }

  Future<void> sttStop() async {
    if (state == PlayState.listening) {
      currState = PlayState.idle;
      //await ref.read(ttsSpeakerProvider.notifier).mute();
      await ref.read(sttRecordProvider.notifier).stopListening();
    }
  }
}

final playWordStateProvider =
    StateNotifierProvider<PlayWordStateNotifier, PlayState>((ref) {
  return PlayWordStateNotifier(ref);
});

class IntroEnableNotifier extends StateNotifier<bool> {
  IntroEnableNotifier() : super(true);

  set enabled(bool val) => state = val;
  bool get enabled => state;
}

final introEnableProvider =
    StateNotifierProvider<IntroEnableNotifier, bool>((ref) {
  return IntroEnableNotifier();
});
