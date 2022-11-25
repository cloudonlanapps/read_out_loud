import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud/pages/custom_widgets/circular_button.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'widgets/main_word.dart';

class SayAloud extends ConsumerStatefulWidget {
  const SayAloud({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayGameState();
}

class _PlayGameState extends ConsumerState<SayAloud> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    final words = result.recognizedWords.split(' ');
    setState(() {
      _lastWords = words.last;
      if (_lastWords.toLowerCase() == "water") {
        _speechToText.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 55, height: 1, color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 32.0),
            child: Text(
              "Can you read this word?",
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 32.0, left: 8.0, right: 8.0),
            child: MainWord(),
          ),
          if (_lastWords != '')
            if (_lastWords.toLowerCase() == "water")
              Text(
                "Well Done",
                style: TextStyle(color: Colors.greenAccent.shade400),
              )
            else ...[
              const Text("Did you say:"),
              Text(
                _lastWords,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.redAccent.shade400),
              )
            ],
          const Spacer(),
          if (_speechEnabled)
            CircularButton(
              height: 20,
              backgroundColor:
                  _speechToText.isListening ? Colors.red.shade400 : null,
              menuButtonItem: CircularButtonItem(
                  icon:
                      _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                  onTap: _speechToText.isNotListening
                      ? _startListening
                      : _stopListening,
                  title: _speechToText.isListening ? "Done" : "Talk"),
            )
          else
            CircleAvatar(
              backgroundColor:
                  _speechToText.isListening ? Colors.red.shade400 : null,
              child: const CircularProgressIndicator(),
            ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}

class Interact extends ConsumerWidget {
  final String utteredWord;
  const Interact({super.key, required this.utteredWord});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        height: 200,
        width: double.infinity,
        color: (utteredWord == '')
            ? Colors.amberAccent.shade400
            : (utteredWord.toLowerCase() == 'water')
                ? Colors.greenAccent.shade400
                : Colors.redAccent.shade400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (utteredWord != '') ...[
              const Text("You said:"),
              Text(
                "You said: $utteredWord",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 55,
                  height: 1,
                ),
              )
            ] else
              const Text(
                "Can you read this word?",
                style: TextStyle(
                  fontSize: 55,
                  letterSpacing: 1.5,
                  height: 1,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
          ],
        ),
      ),
    );
  }
}
