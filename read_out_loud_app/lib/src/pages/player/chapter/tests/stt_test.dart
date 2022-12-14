// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../tts/stt_record.dart';
import '../../../../tts/stt_record_config.dart';

class SpeechSampleApp extends ConsumerStatefulWidget {
  const SpeechSampleApp({super.key});

  @override
  SpeechSampleAppState createState() => SpeechSampleAppState();
}

/// An example that demonstrates the basic functionality of the
/// SpeechToText plugin for using the speech recognition capability
/// of the underlying platform.
class SpeechSampleAppState extends ConsumerState<SpeechSampleApp> {
  STTConfig sttConfig = STTConfig();

  final TextEditingController _pauseForController =
      TextEditingController(text: '3');
  final TextEditingController _listenForController =
      TextEditingController(text: '30');

  @override
  void initState() {
    super.initState();
  }

  /// This initializes SpeechToText. That only has to be done
  /// once per application, though calling it again is harmless
  /// it also does nothing. The UX of the sample app ensures that
  /// it can only be called once.

  @override
  Widget build(BuildContext context) {
    STTRecord sttRecord = ref.watch(sttRecordProvider);
    return Column(children: [
      const HeaderWidget(),
      Column(
        children: <Widget>[
          const InitSpeechWidget(),
          const SpeechControlWidget(),
          SessionOptionsWidget(
            pauseForController: _pauseForController,
            listenForController: _listenForController,
          )
        ],
      ),
      Expanded(
        flex: 4,
        child: RecognitionResultsWidget(
            lastWords: sttRecord.lastWords, level: sttRecord.level),
      ),
      Expanded(
        flex: 1,
        child: ErrorWidget(lastError: sttRecord.lastError),
      ),
      const SpeechStatusWidget(),
    ]);
  }
}

/// Displays the most recently recognized words and the sound level.
class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({
    Key? key,
    required this.lastWords,
    required this.level,
  }) : super(key: key);

  final String lastWords;
  final double level;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Center(
          child: Text(
            'Recognized Words',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.transparent, //Theme.of(context).selectedRowColor,
                child: Center(
                  child: Text(
                    lastWords,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: .26,
                            spreadRadius: level * 1.5,
                            color: Colors.black.withOpacity(.05))
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Speech recognition available',
        style: TextStyle(fontSize: 22.0),
      ),
    );
  }
}

/// Display the current error status from the speech
/// recognizer
class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    Key? key,
    required this.lastError,
  }) : super(key: key);

  final String lastError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Center(
          child: Text(
            'Error Status',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Center(
          child: Text(lastError),
        ),
      ],
    );
  }
}

/// Controls to start and stop speech recognition
class SpeechControlWidget extends ConsumerWidget {
  const SpeechControlWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    STTRecord sttRecord = ref.watch(sttRecordProvider);

    bool hasSpeech = sttRecord.hasSpeech;
    bool isListening = sttRecord.speechToText.isListening;
    ref.watch(sttRecordProvider.select((value) => value.hasSpeech));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed: !hasSpeech || isListening
              ? null
              : ref.read(sttRecordProvider.notifier).startListening,
          child: const Text('Start'),
        ),
        TextButton(
          onPressed: isListening
              ? ref.read(sttRecordProvider.notifier).stopListening
              : null,
          child: const Text('Stop'),
        ),
        TextButton(
          onPressed: isListening
              ? ref.read(sttRecordProvider.notifier).cancelListening
              : null,
          child: const Text('Cancel'),
        )
      ],
    );
  }
}

class SessionOptionsWidget extends ConsumerWidget {
  const SessionOptionsWidget(
      {Key? key,
      required this.pauseForController,
      required this.listenForController})
      : super(key: key);
  final TextEditingController pauseForController;
  final TextEditingController listenForController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    STTRecord sttRecord = ref.watch(sttRecordProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              const Text('Language: '),
              DropdownButton<String>(
                onChanged: (selectedVal) => ref
                    .read(sttRecordProvider.notifier)
                    .switchLang(selectedVal),
                value: sttRecord.currentLocaleId,
                items: sttRecord.localeNames
                    .map(
                      (localeName) => DropdownMenuItem(
                        value: localeName.localeId,
                        child: Text(localeName.name),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          Row(
            children: [
              const Text('pauseFor: '),
              Container(
                  padding: const EdgeInsets.only(left: 8),
                  width: 80,
                  child: TextFormField(
                    controller: pauseForController,
                  )),
              Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: const Text('listenFor: ')),
              Container(
                  padding: const EdgeInsets.only(left: 8),
                  width: 80,
                  child: TextFormField(
                    controller: listenForController,
                  )),
            ],
          ),
          Row(
            children: [
              const Text('On device: '),
              Checkbox(
                value: sttRecord.sttConfig.onDevice,
                onChanged: null, // tODO
              ),
              const Text('Log events: '),
              Checkbox(
                value: sttRecord.logEvents,
                onChanged: ref.read(sttRecordProvider.notifier).switchLogging,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InitSpeechWidget extends ConsumerWidget {
  const InitSpeechWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool hasSpeech =
        ref.watch(sttRecordProvider.select((value) => value.hasSpeech));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed:
              hasSpeech ? null : ref.read(sttRecordProvider.notifier).init,
          child: const Text('Initialize'),
        ),
      ],
    );
  }
}

/// Display the current status of the listener
class SpeechStatusWidget extends ConsumerWidget {
  const SpeechStatusWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    STTRecord sttRecord = ref.watch(sttRecordProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: sttRecord.speechToText.isListening
            ? const Text(
                "I'm listening...",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : const Text(
                'Not listening',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
