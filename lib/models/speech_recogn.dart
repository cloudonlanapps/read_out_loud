// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../providers/word_provider.dart';
import 'tts.dart';

class SpeechRecog {
  late final SpeechToText speechToText;
  final bool speechEnabled;
  final bool isListening;
  final bool paused;

  SpeechRecog({
    SpeechToText? speechToText,
    this.speechEnabled = false,
    this.isListening = false,
    this.paused = false,
  }) {
    this.speechToText = speechToText ?? SpeechToText();
  }

  SpeechRecog copyWith({
    bool? speechEnabled,
    bool? isListening,
    bool? paused,
  }) {
    return SpeechRecog(
        speechToText: speechToText,
        speechEnabled: speechEnabled ?? this.speechEnabled,
        isListening: isListening ?? this.isListening,
        paused: paused ?? this.paused);
  }

  bool get isNotListening => !isListening;

  Future<void> listen(
      void Function(SpeechRecognitionResult speechRecognitionResult)
          updateSpokenWords) async {
    if (speechEnabled) {
      await speechToText.listen(onResult: updateSpokenWords);
    }
  }

  Future<void> stop() async {
    if (speechEnabled) {
      await speechToText.stop();
    }
  }
}

class SpeechRecogNotifier extends StateNotifier<SpeechRecog> {
  final Ref ref;
  SpeechRecogNotifier(this.ref) : super(SpeechRecog()) {
    init();
  }

  Future<void> init() async {
    final bool speechEnabled = await state.speechToText.initialize();
    state = state.copyWith(speechEnabled: speechEnabled);
    //listen();
  }

  Future<void> listen() async {
    if (!state.speechEnabled) {
      await init();
    }
    await state.listen(onResult);
    state = state.copyWith(isListening: state.speechToText.isListening);
  }

  Future<void> stop() async {
    await state.stop();
    state = state.copyWith(isListening: state.speechToText.isListening);
  }

  Future<void> pause() async {
    if (!state.paused) {
      state = state.copyWith(paused: true);
    }
  }

  Future<void> resume() async {
    if (state.paused) {
      //await state.speechToText.cancel();
      if (state.isListening) {
        await stop();
        await listen();
      }
      state = state.copyWith(paused: false);
    }
  }

  Future<void> onResult(SpeechRecognitionResult speechRecognitionResult) async {
    if (!state.paused) {
      state = state.copyWith(paused: true);
      final recognizedWords = speechRecognitionResult.recognizedWords;

      await ref.read(wordsProvider.notifier).recognizedWords(
          spokenText: recognizedWords.split(' ').last,
          onSuccess: () async {
            await reset();
            await ref.read(ttspeechProvider.notifier).speak('Well Done');
          },
          onFail: onFail,
          introNextWord: introNextWord);
      state = state.copyWith(paused: false);
    }
  }

  introNextWord() async {
    await ref.read(ttspeechProvider.notifier).speak('Can you read this word?');
  }

  onFail() async {
    await reset();
    await ref
        .read(ttspeechProvider.notifier)
        .speak('Wrong.. Can you try again?');
  }

  reset() async {
    await stop();
    await listen();
  }

  previous() async {
    await pause();
    ref.read(wordsProvider.notifier).previous();
    await ref.read(ttspeechProvider.notifier).speak('Can you reads this word?');
    await Future.delayed(const Duration(microseconds: 1000));
    await resume();
    await reset();
  }

  next() async {
    await pause();
    ref.read(wordsProvider.notifier).next();

    await ref.read(ttspeechProvider.notifier).speak('Can you reads this word?');
    await resume();
    if (!state.isListening) {
      await reset();
    }
  }
}

final speechRecogProvider =
    StateNotifierProvider<SpeechRecogNotifier, SpeechRecog>((ref) {
  return SpeechRecogNotifier(ref);
});
