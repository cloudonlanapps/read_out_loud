// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'tts_speaker_config.dart';

enum TTSState { playing, stopped }

class TTSSpeaker {
  final FlutterTts flutterTts;
  final TTSSpeakerConfig config;
  final TTSState ttsState;
  final bool isMuted;

  TTSSpeaker({
    required this.config,
    FlutterTts? flutterTts,
    this.ttsState = TTSState.stopped,
    this.isMuted = false,
  }) : flutterTts = flutterTts ?? FlutterTts() {
    init();
  }

  TTSSpeaker copyWith({
    TTSState? ttsState,
    bool? isMuted,
  }) {
    return TTSSpeaker(
      config: config,
      flutterTts: flutterTts,
      ttsState: ttsState ?? this.ttsState,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  get isPlaying => ttsState == TTSState.playing;
  get isStopped => ttsState == TTSState.stopped;

  init() {
    _setAwaitOptions();
    flutterTts.setLanguage(config.language);

    if (config.isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      // print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      // print(voice);
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }
}

class TTSSpeakerNotifier extends StateNotifier<TTSSpeaker> {
  bool cancelling = false;
  TTSSpeakerNotifier({required TTSSpeakerConfig config})
      : super(TTSSpeaker(config: config)) {
    state.flutterTts.setErrorHandler(setErrorHandler);
  }

  updateState(TTSState newState) {
    state = state.copyWith(ttsState: newState);
  }

  // Return only if
  Future play(String text,
      {Function()? onComplete, Function()? onCancel}) async {
    if (state.isMuted) {
      onCancel?.call();
      cancelling = false;
      return;
    }
    if (state.isPlaying) {
      await stop();
    }
    if (text.isNotEmpty) {
      state.flutterTts.setStartHandler(() {
        updateState(TTSState.playing);
      });
      state.flutterTts.setCompletionHandler(() {
        updateState(TTSState.stopped);
        if (cancelling) {
          onCancel?.call();
        } else {
          onComplete?.call();
        }
        cancelling = false;
      });
      state.flutterTts.setCancelHandler(() {
        updateState(TTSState.stopped);
        onCancel?.call();
        cancelling = false;
      });
      await state.flutterTts.setVolume(state.config.volume);
      await state.flutterTts.setSpeechRate(state.config.rate);
      await state.flutterTts.setPitch(state.config.pitch);
      await state.flutterTts.speak(text);
    }
  }

  Future stop({Function()? callback}) async {
    if (!state.isMuted) {
      cancelling = true;
      if (!state.isStopped) {
        var result = await state.flutterTts.stop();
        if (result == 1) {
          updateState(TTSState.stopped);
        }
      }
    }
    callback?.call();
  }

  void setErrorHandler(dynamic msg) {
    // ignore: todo
    // TODO: Need to handle error!!
    //print("Error reported from flutterTTS $msg");
  }

  mute() async {
    if (state.isMuted) {
      return;
    }
    if (state.isPlaying) {
      await stop();
    }
    state = state.copyWith(isMuted: true);
  }

  unmute() async {
    if (!state.isMuted) {
      return;
    }
    state = state.copyWith(isMuted: false);
  }
}

final ttsSpeakerProvider =
    StateNotifierProvider<TTSSpeakerNotifier, TTSSpeaker>((ref) {
  // To be obtained from preferences later
  TTSSpeakerConfig config =
      TTSSpeakerConfig(isAndroid: !kIsWeb && Platform.isAndroid);
  return TTSSpeakerNotifier(config: config);
});
