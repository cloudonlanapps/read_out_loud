import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';
import '../../tts/tts_speaker.dart';

class AudioPlayerConfig extends ConsumerStatefulWidget {
  const AudioPlayerConfig({super.key});

  @override
  AudioPlayerConfigState createState() => AudioPlayerConfigState();
}

enum TtsState {
  playing,
  stopped,
}

class AudioPlayerConfigState extends ConsumerState<AudioPlayerConfig> {
  final textStyle = const TextStyle(color: Colors.blueGrey, fontSize: 20);
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TTSSpeaker ttsSpeaker = ref.watch(ttsSpeakerProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 24, bottom: 24, left: 8, right: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), border: Border.all()),
            padding: const EdgeInsets.all(8),
            child: Text(
              ttsSpeaker.sampleText,
              style: textStyle,
            ),
          ),
          ...[
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () async {
                      ref.watch(ttsSpeakerProvider.notifier).volume = 0.5;
                      ref.watch(ttsSpeakerProvider.notifier).pitch = 1.0;
                      ref.watch(ttsSpeakerProvider.notifier).rate = 0.5;
                    },
                    child: const Text("Reset"))),
            Slider(
                value: ttsSpeaker.volume,
                onChanged: (value) {
                  ref.watch(ttsSpeakerProvider.notifier).volume = value;
                },
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: "Volume: ${ttsSpeaker.volume}"),
            Slider(
              value: ttsSpeaker.pitch,
              onChanged: (value) {
                ref.watch(ttsSpeakerProvider.notifier).pitch = value;
              },
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: "Pitch: ${ttsSpeaker.volume}",
            ),
            Slider(
              value: ttsSpeaker.rate,
              onChanged: (value) {
                ref.watch(ttsSpeakerProvider.notifier).rate = value;
              },
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: "Rate: ${ttsSpeaker.rate}",
            ),
          ],
          Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 24, left: 8, right: 8),
            child: CustomMenu(menuItems: [
              null,
              CustomMenuItem(
                  alignment: Alignment.bottomCenter,
                  icon: Icons.play_arrow,
                  color: Colors.greenAccent,
                  onTap: () async {
                    await ref.read(ttsSpeakerProvider.notifier).play(
                        ttsSpeaker.sampleText * 4,
                        onComplete: () {},
                        onCancel: () {});
                  },
                  title: 'Play'),
              CustomMenuItem(
                  alignment: Alignment.bottomCenter,
                  icon: Icons.stop,
                  color: Colors.redAccent,
                  onTap: () async {
                    await ref.read(ttsSpeakerProvider.notifier).stop();
                  },
                  title: 'Stop'),
              null,
            ]),
          ),

          FutureBuilder<dynamic>(
              future: ttsSpeaker.getLanguages(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton(
                              value: ttsSpeaker.language,
                              items:
                                  getLanguageDropDownMenuItems(snapshot.data),
                              onChanged: (val) =>
                                  changedLanguageDropDownItem(ttsSpeaker, val),
                            ),
                            Visibility(
                              visible: ttsSpeaker.isAndroid,
                              child: Text(
                                  "Is installed: ${ttsSpeaker.isCurrentLanguageInstalled}"),
                            ),
                          ]));
                } else if (snapshot.hasError) {
                  return const Text('Error loading languages...');
                } else {
                  return const Text('Loading Languages...');
                }
              })

          //_engineSection(),
          //_futureBuilder(),
          //_buildSliders(),
          //if (isAndroid) _getMaxSpeechInputLengthSection(),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(TTSSpeaker ttsSpeaker, String? language) {
    ttsSpeaker.flutterTts.setLanguage(language!);
    ref.watch(ttsSpeakerProvider.notifier).language = language;
    if (ttsSpeaker.isAndroid) {
      ttsSpeaker.flutterTts.isLanguageInstalled(language).then((value) => ref
          .watch(ttsSpeakerProvider.notifier)
          .isCurrentLanguageInstalled = (value as bool));
    }

    /* setState(() {
      language = selectedType;
      flutterTts.setLanguage(language!);
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    }); */
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedEnginesDropDownItem(String? selectedEngine) async {
    /*  await flutterTts.setEngine(selectedEngine!);
    language = null;
    setState(() {
      engine = selectedEngine;
    }); */
  }
}
