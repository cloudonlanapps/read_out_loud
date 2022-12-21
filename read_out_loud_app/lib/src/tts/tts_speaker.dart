// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TTSState { playing, stopped }

class TTSSpeaker {
  final FlutterTts flutterTts;

  final TTSState ttsState;
  final bool isMuted;

  final String sampleText;
  final bool isAndroid;
  final String? engine;
  final String language;
  final double volume;
  final double pitch;
  final double rate;
  final bool? isCurrentLanguageInstalled;

  TTSSpeaker({
    required this.isAndroid,
    this.sampleText = 'The quick brown fox jumps over the lazy dog.',
    this.engine,
    this.language = 'en-US',
    this.volume = 0.5,
    this.pitch = 1.0,
    this.rate = 0.5,
    this.isCurrentLanguageInstalled,
    FlutterTts? flutterTts,
    this.ttsState = TTSState.stopped,
    this.isMuted = false,
  }) : flutterTts = flutterTts ?? FlutterTts() {
    init();
  }

  TTSSpeaker copyWith({
    FlutterTts? flutterTts,
    TTSState? ttsState,
    bool? isMuted,
    String? sampleText,
    bool? isAndroid,
    String? engine,
    String? language,
    double? volume,
    double? pitch,
    double? rate,
    bool? isCurrentLanguageInstalled,
  }) {
    return TTSSpeaker(
      flutterTts: flutterTts ?? this.flutterTts,
      ttsState: ttsState ?? this.ttsState,
      isMuted: isMuted ?? this.isMuted,
      sampleText: sampleText ?? this.sampleText,
      isAndroid: isAndroid ?? this.isAndroid,
      engine: engine ?? this.engine,
      language: language ?? this.language,
      volume: volume ?? this.volume,
      pitch: pitch ?? this.pitch,
      rate: rate ?? this.rate,
      isCurrentLanguageInstalled:
          isCurrentLanguageInstalled ?? this.isCurrentLanguageInstalled,
    );
  }

  bool get isPlaying => ttsState == TTSState.playing;
  bool get isStopped => ttsState == TTSState.stopped;

  void init() {
    _setAwaitOptions();
    flutterTts.setLanguage(language);

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }
  }

  Future _getDefaultEngine() async {
    final engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      // print(engine);
    }
  }

  Future _getDefaultVoice() async {
    final voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      // print(voice);
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<List<String>> getLanguages() async {
    final languages = await flutterTts.getLanguages;
    final installedLanguages = <String>[];
    for (final language in languages
        .where((e) => (e as String).startsWith('en')) as List<String>) {
      await flutterTts.isLanguageInstalled(language).then((value) {
        if (value as bool) {
          installedLanguages.add(language);
        }
      });
    }
    return installedLanguages.map((e) => e).toList()..sort();
  }

  Future<dynamic> getEngines() async => flutterTts.getEngines;
}

class TTSSpeakerNotifier extends StateNotifier<TTSSpeaker> {
  bool cancelling = false;
  TTSSpeakerNotifier({required bool isAndroid})
      : super(TTSSpeaker(isAndroid: isAndroid)) {
    state.flutterTts.setErrorHandler(setErrorHandler);
  }

  void updateState(TTSState newState) {
    state = state.copyWith(ttsState: newState);
  }

  // Return only if
  Future play(
    String text, {
    Function()? onComplete,
    Function()? onCancel,
  }) async {
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
      await state.flutterTts.setVolume(state.volume);
      await state.flutterTts.setSpeechRate(state.rate);
      await state.flutterTts.setPitch(state.pitch);
      updateState(TTSState.playing);
      await state.flutterTts.speak(text);
    }
  }

  Future stop({Function()? callback}) async {
    if (!state.isMuted) {
      cancelling = true;
      if (!state.isStopped) {
        final result = await state.flutterTts.stop();
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

  Future<void> mute() async {
    if (state.isMuted) {
      return;
    }
    if (state.isPlaying) {
      await stop();
    }
    state = state.copyWith(isMuted: true);
  }

  Future<void> unmute() async {
    if (!state.isMuted) {
      return;
    }
    state = state.copyWith(isMuted: false);
  }

  set volume(double value) => state = state.copyWith(volume: value);
  set pitch(double value) => state = state.copyWith(pitch: value);
  set rate(double value) => state = state.copyWith(rate: value);

  set isCurrentLanguageInstalled(bool? val) =>
      state = state.copyWith(isCurrentLanguageInstalled: val);
  set language(String val) => state = state.copyWith(language: val);
  set engine(String? val) => state = state.copyWith(engine: val);

  double get volume => state.volume;
  double get pitch => state.pitch;
  double get rate => state.rate;

  bool? get isCurrentLanguageInstalled => state.isCurrentLanguageInstalled;
  String get language => state.language;
  String? get engine => state.engine;

  void restoreDefault() {
    state = state.copyWith(volume: 0.5, pitch: 1, rate: 0.5, language: 'en-US');
  }
}

final ttsSpeakerProvider =
    StateNotifierProvider<TTSSpeakerNotifier, TTSSpeaker>((ref) {
  // To be obtained from preferences later

  return TTSSpeakerNotifier(isAndroid: !kIsWeb && Platform.isAndroid);
});
