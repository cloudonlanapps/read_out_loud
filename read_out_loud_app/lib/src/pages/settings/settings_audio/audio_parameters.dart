import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../tts/tts_speaker.dart';

class AudioParameters extends ConsumerStatefulWidget {
  const AudioParameters({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AudioParametersState();
}

class _AudioParametersState extends ConsumerState<AudioParameters> {
  @override
  Widget build(BuildContext context) {
    final ttsSpeaker = ref.watch(ttsSpeakerProvider);
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  ref.read(ttsSpeakerProvider.notifier).restoreDefault();
                },
                child: const Text('Reset'),
              ),
            ),
            if (Platform.isAndroid)
              FutureBuilder<dynamic>(
                future: ttsSpeaker.getEngines(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if ((snapshot.data as List<dynamic>).length == 1) {
                      return Container();
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  'Engines: ',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: FittedBox(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: DropdownButton(
                                  value: ttsSpeaker.engine,
                                  items: getEnginesDropDownMenuItems(
                                    snapshot.data,
                                  ),
                                  onChanged: (val) =>
                                      changedEnginesDropDownItem(
                                    ttsSpeaker,
                                    val,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Text('Error loading engines...');
                  } else {
                    return const Text('Loading engines...');
                  }
                },
              ),
            if (Platform.isAndroid)
              FutureBuilder<dynamic>(
                future: ttsSpeaker.getLanguages(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                'Language: ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FittedBox(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: DropdownButton(
                                value: ttsSpeaker.language,
                                items: getLanguageDropDownMenuItems(
                                  snapshot.data,
                                ),
                                onChanged: (val) => changedLanguageDropDownItem(
                                  ttsSpeaker,
                                  val,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error loading languages...');
                  } else {
                    return const Text('Loading Languages...');
                  }
                },
              ),
            Slider(
              value: ttsSpeaker.volume,
              onChanged: (value) {
                ref.watch(ttsSpeakerProvider.notifier).volume = value;
              },
              divisions: 10,
              label: 'Volume: ${ttsSpeaker.volume}',
            ),
            Slider(
              value: ttsSpeaker.pitch,
              onChanged: (value) {
                ref.watch(ttsSpeakerProvider.notifier).pitch = value;
              },
              min: 0.5,
              max: 2,
              divisions: 15,
              label: 'Pitch: ${ttsSpeaker.volume}',
            ),
            Slider(
              value: ttsSpeaker.rate,
              onChanged: (value) {
                ref.watch(ttsSpeakerProvider.notifier).rate = value;
              },
              divisions: 10,
              label: 'Rate: ${ttsSpeaker.rate}',
            ),
            if (ttsSpeaker.isAndroid)
              FutureBuilder(
                future: ttsSpeaker.flutterTts.getMaxSpeechInputLength,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Max input length: ${snapshot.data}');
                  } else if (snapshot.hasError) {
                    return const Text('Error loading languages...');
                  } else {
                    return const Text('Loading input Length...');
                  }
                },
              )
          ],
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
    dynamic languages,
  ) {
    final items = <DropdownMenuItem<String>>[];
    for (final String type in languages) {
      items.add(
        DropdownMenuItem(
          value: type,
          child: Text(type),
        ),
      );
    }
    return items;
  }

  void changedLanguageDropDownItem(TTSSpeaker ttsSpeaker, String? language) {
    if (ttsSpeaker.language != language) {
      ttsSpeaker.flutterTts.setLanguage(language!);
      ref.read(ttsSpeakerProvider.notifier).language = language;
      if (ttsSpeaker.isAndroid) {
        ttsSpeaker.flutterTts.isLanguageInstalled(language).then(
              (value) => ref
                  .read(ttsSpeakerProvider.notifier)
                  .isCurrentLanguageInstalled = value as bool,
            );
      }
    }
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    final items = <DropdownMenuItem<String>>[];
    for (final String type in engines) {
      items.add(
        DropdownMenuItem(
          value: type,
          child: Text(type),
        ),
      );
    }
    return items;
  }

  Future<void> changedEnginesDropDownItem(
    TTSSpeaker ttsSpeaker,
    String? engine,
  ) async {
    if (ttsSpeaker.engine != engine) {
      ref.read(ttsSpeakerProvider.notifier).engine = engine;
    }
  }
}
