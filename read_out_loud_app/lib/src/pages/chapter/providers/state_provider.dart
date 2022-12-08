import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud_app/src/tts/stt_record.dart';

import '../../../tts/tts_speaker.dart';

enum PlayState { idle, intro, listening, reading }

class ContentListConfig {
  final String filename;
  ContentListConfig({
    required this.filename,
  });

  @override
  bool operator ==(covariant ContentListConfig other) {
    if (identical(this, other)) return true;

    return other.filename == filename;
  }

  @override
  int get hashCode => filename.hashCode;
}

class PlayWordStateNotifier extends StateNotifier<PlayState> {
  Ref ref;
  PlayWordStateNotifier(this.ref) : super(PlayState.idle);

  set newState(PlayState val) {
    // print("State changed to $val");
    state = val;
  }

  speak({required String text, PlayState? playState}) async {
    if ((state != PlayState.idle)) return;
    ref.read(playWordStateProvider.notifier).newState =
        playState ?? PlayState.reading;
    await ref.read(ttsSpeakerProvider.notifier).play(text,
        onComplete: () =>
            ref.read(playWordStateProvider.notifier).newState = PlayState.idle,
        onCancel: () =>
            ref.read(playWordStateProvider.notifier).newState = PlayState.idle);
  }

  sttListen() async {
    if (state == PlayState.idle) {
      newState = PlayState.listening;
      //await ref.read(ttsSpeakerProvider.notifier).mute();
      await ref.read(sttRecordProvider.notifier).startListening();
    }
  }
}

final playWordStateProvider =
    StateNotifierProvider<PlayWordStateNotifier, PlayState>((ref) {
  return PlayWordStateNotifier(ref);
});
