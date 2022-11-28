// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud/pages/games/widgets/bottom_menu.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../providers/word_provider.dart';
import 'widgets/main_word.dart';
import 'widgets/utterred_word.dart';

class SayAloud extends ConsumerStatefulWidget {
  final String wordListFile;
  const SayAloud({
    super.key,
    this.wordListFile = 'assets/wordlist1.json',
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SayAloudState();
}

class SayAloudState extends ConsumerState<SayAloud> {
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
    await _speechToText.listen(
        onResult: (result) => _onSpeechResult(ref, result));
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
  void _onSpeechResult(WidgetRef ref, SpeechRecognitionResult result) {
    final words = result.recognizedWords.split(' ');
    ref.read(wordsProvider(widget.wordListFile).notifier).recognizedWords(
        spokenText: words.last,
        onSuccess: () {
          _speechToText.stop();
        });
    setState(() {
      _lastWords = words.last;
      if (_lastWords.toLowerCase() == "water") {
        _speechToText.stop();
      }
    });
    /* ref.read(wordsProvider.notifier).recognizedWords(
        spokenText: result.recognizedWords,
        onSuccess: () {
          _speechToText.stop();
        }); */
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 55, height: 1, color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "Can you read this word?",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: MainWord(wordListFile: widget.wordListFile),
            ),
          ),
          Flexible(
            child: UtterredWord(
              wordListFile: widget.wordListFile,
            ),
          ),
          const Flexible(
            child: SizedBox(
              height: 32,
            ),
          ),
          BottomMenu(
              wordListFile: widget.wordListFile,
              speechEnabled: _speechEnabled,
              speechToText: _speechToText,
              onTapRecord: _speechToText.isNotListening
                  ? _startListening
                  : _stopListening)
        ],
      ),
    );
  }
}

//Unused
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
