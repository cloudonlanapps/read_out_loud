// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'stt_record_config.dart';
import 'tts_speaker.dart';

enum STTState { listening, stopped }

class STTRecord {
  STTConfig sttConfig;
  bool hasSpeech;
  SpeechToText speechToText;
  double level;
  String lastWords;
  String lastError = '';
  String lastStatus = '';
  String currentLocaleId;
  List<LocaleName> localeNames;
  bool logEvents;
  STTRecord({
    required this.sttConfig,
    this.hasSpeech = false,
    SpeechToText? speechToText,
    this.level = 0.0,
    this.lastWords = '',
    this.lastError = '',
    this.lastStatus = '',
    this.currentLocaleId = '',
    List<LocaleName>? localeNames,
    this.logEvents = true,
  })  : speechToText = speechToText ?? SpeechToText(),
        localeNames = localeNames ?? [];

  STTRecord copyWith({
    STTConfig? sttConfig,
    bool? hasSpeech,
    SpeechToText? speechToText,
    double? level,
    String? lastWords,
    String? lastError,
    String? lastStatus,
    String? currentLocaleId,
    List<LocaleName>? localeNames,
    bool? logEvents,
  }) {
    return STTRecord(
      sttConfig: sttConfig ?? this.sttConfig,
      hasSpeech: hasSpeech ?? this.hasSpeech,
      speechToText: speechToText ?? this.speechToText,
      level: level ?? this.level,
      lastWords: lastWords ?? this.lastWords,
      lastError: lastError ?? this.lastError,
      lastStatus: lastStatus ?? this.lastStatus,
      currentLocaleId: currentLocaleId ?? this.currentLocaleId,
      localeNames: localeNames ?? this.localeNames,
      logEvents: logEvents ?? this.logEvents,
    );
  }

  void logEvent(String eventDescription) {
    if (logEvents) {
      //var eventTime = DateTime.now().toIso8601String();
      // ignore: todo
      //TODO Logger print('$eventTime $eventDescription');
    }
  }

  Future<STTRecord> init(
      {required void Function(SpeechRecognitionError error) onError,
      required void Function(String status) onStatus}) async {
    logEvent('Initialize');
    try {
      var hasSpeech = await speechToText.initialize(
        onError: onError,
        onStatus: onStatus,
        debugLogging: logEvents,
      );
      if (!hasSpeech) {
        throw Exception("initialize returned false");
      }

      var localeNames = await speechToText.locales();

      var systemLocale = await speechToText.systemLocale();
      String currentLocaleId = systemLocale?.localeId ?? '';

      // Get the list of languages installed on the supporting platform so they
      // can be displayed in the UI for selection by the user.

      return copyWith(
          hasSpeech: hasSpeech,
          currentLocaleId: currentLocaleId,
          localeNames: localeNames);
    } catch (e) {
      return copyWith(
          lastError: 'Speech recognition failed: ${e.toString()}',
          hasSpeech: false);
    }
  }
}

class STTRecordNotifier extends StateNotifier<STTRecord> {
  Ref ref;
  STTRecordNotifier(this.ref) : super(STTRecord(sttConfig: STTConfig())) {
    //init();
  }
  init() async {
    state = await state.init(onError: errorListener, onStatus: statusListener);
  }

  void soundLevelListener(double level) {
    double temp = min(state.sttConfig.minSoundLevel, level);
    temp = max(state.sttConfig.maxSoundLevel, temp);
    state = state.copyWith(level: temp);
  }

  void switchLang(selectedVal) {
    state = state.copyWith(currentLocaleId: selectedVal);
    state.logEvent("selectedVal = $selectedVal");
  }

  void switchLogging(bool? val) {
    state = state.copyWith(logEvents: val);
  }

  void errorListener(SpeechRecognitionError error) {
    state.logEvent(
        'Received error status: $error, listening: ${state.speechToText.isListening}');

    state = state.copyWith(lastError: '${error.errorMsg} - ${error.permanent}');
  }

  void statusListener(String status) {
    state = state.copyWith(lastStatus: status);

    state.logEvent(
        'Received listener status: $status, listening: ${state.speechToText.isListening}');
  }

  // This is called each time the users wants to start a new speech
  // recognition session
  //(pauseFor = int.tryParse(_pauseForController.text, int.tryParse(_listenForController.text)))
  Future<void> startListening({int? listenFor, int? pauseFor}) async {
    if (!state.hasSpeech) {
      await init();
    }
    if (!state.hasSpeech) {
      return;
    }
    state.logEvent('start listening');

    state = state.copyWith(lastWords: '', lastError: '');

    // Note that `listenFor` is the maximum, not the minimun, on some
    // systems recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    await state.speechToText.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: listenFor ?? 30),
      pauseFor: Duration(seconds: pauseFor ?? 3),
      partialResults: true,
      localeId: state.currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.dictation,
      onDevice: state.sttConfig.onDevice,
    );
  }

  void stopListening() async {
    state.logEvent('stop');
    state.speechToText.stop();
    state = state.copyWith(level: 0.0);
    await ref.read(ttsSpeakerProvider.notifier).unmute();
  }

  void cancelListening() async {
    state.logEvent('cancel');
    state.speechToText.cancel();
    state = state.copyWith(level: 0.0);
    await ref.read(ttsSpeakerProvider.notifier).unmute();
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    state.logEvent('STT Result: words: ${result.recognizedWords}');
    state = state.copyWith(lastWords: result.recognizedWords);
  }

  void clearWord() {
    state = state.copyWith(lastWords: '');
  }
}

final sttRecordProvider =
    StateNotifierProvider<STTRecordNotifier, STTRecord>((ref) {
  return STTRecordNotifier(ref);
});
