import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TTSSpeaker {
  late FlutterTts flutterTts;
  final String language;
  final String? engine;
  final double volume;
  final double pitch;
  final double rate;
  final bool isCurrentLanguageInstalled;
  TtsState ttsState;
  Function(TtsState ttsState)? onStateChange;

  TTSSpeaker({
    this.onStateChange,
    this.language = 'en-US',
    this.engine,
    this.volume = 0.5,
    this.pitch = 1.0,
    this.rate = 0.5,
    this.isCurrentLanguageInstalled = false,
    this.ttsState = TtsState.stopped,
  });

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  init({required bool isAndroid}) {
    flutterTts = FlutterTts();

    _setAwaitOptions();
    flutterTts.setLanguage(language);

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
      onStateChange?.call(ttsState);
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        onStateChange?.call(ttsState);
      });
    }

    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
      onStateChange?.call(ttsState);
    });

    flutterTts.setCancelHandler(() {
      ttsState = TtsState.stopped;
      onStateChange?.call(ttsState);
    });

    flutterTts.setPauseHandler(() {
      ttsState = TtsState.paused;
      onStateChange?.call(ttsState);
    });

    flutterTts.setContinueHandler(() {
      ttsState = TtsState.continued;
      onStateChange?.call(ttsState);
    });

    flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stopped;

      onStateChange?.call(ttsState);
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future speak(String text) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      ttsState = TtsState.stopped;
    }
    onStateChange?.call(ttsState);
  }

  Future pause() async {
    var result = await flutterTts.pause();
    if (result == 1) {
      ttsState = TtsState.paused;
    }
    onStateChange?.call(ttsState);
  }
}
