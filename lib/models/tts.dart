// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_element
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TTSState { playing, stopped, paused, continued }

enum OSSupported { android, ios }

getOS() {
  if (!kIsWeb && Platform.isIOS) {
    return OSSupported.ios;
  }
  if (!kIsWeb && Platform.isAndroid) {
    return OSSupported.android;
  }
  throw Exception("Unsupported Platform");
}

class TTSpeech {
  late final FlutterTts flutterTts;
  //late final dynamic engine;
  //late final dynamic voice;
  final bool ready;
  final bool isSpeaking;
  final double volume = 1.0;
  final double pitch = 1.0;
  final double rate = 0.5;

  TTSpeech({
    FlutterTts? flutterTts,
    this.ready = false,
    this.isSpeaking = false,
  }) {
    this.flutterTts = flutterTts ?? FlutterTts();
  }

  TTSpeech copyWith({
    bool? ready,
    bool? isSpeaking,
  }) {
    return TTSpeech(
      flutterTts: flutterTts,
      ready: ready ?? this.ready,
      isSpeaking: isSpeaking ?? this.isSpeaking,
    );
  }

  ///--- init() ---
  init() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setSharedInstance(true); //ios

    await flutterTts.setLanguage('en-US');

    //print(await _getLanguages());
    // print(await _getEngines());
    registerCallbacks(
      startHandler: () {
        print("started");
      },
      completionHandler: () {
        print("Completed");
      },
    );
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      //  print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      // print(voice);
    }
  }

  Future<void> speak(String newVoiceText) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (newVoiceText.isNotEmpty) {
      print("Speaking $newVoiceText");
      await flutterTts.speak(newVoiceText);
    }
  }

  Future<bool> stop() async {
    return await flutterTts.stop();
    // if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future<bool> pause() async {
    return await flutterTts.pause();
    //if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  registerCallbacks(
      {Function()? startHandler,
      Function()? initHandler,
      Function()? completionHandler,
      Function()? cancelHandler,
      Function()? pauseHandler,
      Function()? continueHandler,
      Function(dynamic msg)? errorHandler}) {
    if (startHandler != null) {
      flutterTts.setStartHandler(startHandler);
    }
    if (initHandler != null) {
      flutterTts.setInitHandler(initHandler);
    }
    if (completionHandler != null) {
      flutterTts.setCompletionHandler(completionHandler);
    }
    if (cancelHandler != null) {
      flutterTts.setCancelHandler(cancelHandler);
    }
    if (pauseHandler != null) {
      flutterTts.setPauseHandler(pauseHandler);
    }
    if (continueHandler != null) {
      flutterTts.setContinueHandler(continueHandler);
    }
    if (errorHandler != null) {
      flutterTts.setErrorHandler(errorHandler);
    }
  }
}

class TTSpeechNotifier extends StateNotifier<TTSpeech> {
  Ref ref;
  TTSpeechNotifier(this.ref) : super(TTSpeech()) {
    init();
  }

  Future<void> init() async {
    await state.init();
    state = state.copyWith(ready: true);
  }

  Future<void> speak(String newVoiceText) async {
    if (!state.ready) {
      await init();
      if (!state.ready) {
        return;
      }
    }
    state = state.copyWith(isSpeaking: true);
    await state.speak(newVoiceText);
    state = state.copyWith(isSpeaking: false);
  }
}

final ttspeechProvider =
    StateNotifierProvider<TTSpeechNotifier, TTSpeech>((ref) {
  return TTSpeechNotifier(ref);
});
