// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../providers/word_provider.dart';

class SpeechRecog {
  late final SpeechToText speechToText;
  final bool speechEnabled;
  final bool isListening;

  SpeechRecog({
    SpeechToText? speechToText,
    this.speechEnabled = false,
    this.isListening = false,
  }) {
    this.speechToText = speechToText ?? SpeechToText();
  }

  SpeechRecog copyWith({
    bool? speechEnabled,
    bool? isListening,
  }) {
    return SpeechRecog(
        speechToText: speechToText,
        speechEnabled: speechEnabled ?? this.speechEnabled,
        isListening: isListening ?? this.isListening);
  }

  bool get isNotListening => !isListening;
}

class SpeechRecogNotifier extends StateNotifier<SpeechRecog> {
  final Ref ref;
  SpeechRecogNotifier(this.ref) : super(SpeechRecog()) {
    init();
  }

  Future<void> init() async {
    final bool speechEnabled = await state.speechToText.initialize();
    state = state.copyWith(speechEnabled: speechEnabled);
    listen();
  }

  Future<void> listen() async {
    await state.speechToText.listen(onResult: onResult);
    state = state.copyWith(isListening: state.speechToText.isListening);
  }

  Future<void> stop() async {
    await state.speechToText.stop();
    state = state.copyWith(isListening: state.speechToText.isListening);
  }

  Future<void> toggleListening() async {
    if (state.isListening) {
      await stop();
    } else {
      await listen();
    }
  }

  onResult(SpeechRecognitionResult speechRecognitionResult) async {
    final recognizedWords = speechRecognitionResult.recognizedWords;
    await stop();
    await ref.read(wordsProvider.notifier).recognizedWords(
        spokenText: recognizedWords.split(' ').last,
        onSuccess: () {
          // state.stop();
        });
    await listen();
  }
}

final speechRecogProvider =
    StateNotifierProvider<SpeechRecogNotifier, SpeechRecog>((ref) {
  return SpeechRecogNotifier(ref);
});
