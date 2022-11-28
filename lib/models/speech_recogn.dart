// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../providers/word_provider.dart';

class SpeechRecog {
  late final SpeechToText speechToText;
  final bool speechEnabled;

  SpeechRecog({
    SpeechToText? speechToText,
    this.speechEnabled = false,
  }) {
    this.speechToText = speechToText ?? SpeechToText();
  }

  SpeechRecog copyWith({
    bool? speechEnabled,
  }) {
    return SpeechRecog(
      speechToText: speechToText,
      speechEnabled: speechEnabled ?? this.speechEnabled,
    );
  }

  bool get isListening => speechToText.isListening;
  bool get isNotListening => speechToText.isNotListening;

  listen(Function(SpeechRecognitionResult) callback) async {
    await speechToText.listen(onResult: callback);
  }

  stop() async {
    await speechToText.stop();
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
    listen();
  }

  Future<void> listen() async {
    await state.listen((SpeechRecognitionResult speechRecognitionResult) =>
        onResult(speechRecognitionResult));
  }

  Future<void> stop() async {
    await state.stop();
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
