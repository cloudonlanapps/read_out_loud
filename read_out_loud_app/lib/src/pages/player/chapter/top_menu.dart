import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manage_content/manage_content.dart';

import '../../../custom_widgets/custom_menu.dart';
import '../../../tts/stt_record.dart';
import '../../../tts/tts_speaker.dart';
import 'providers/state_provider.dart';

class TopMenu extends ConsumerWidget {
  final ContentListConfig contentListConfig;
  final Size size;
  final Function() onClose;
  const TopMenu(
      {super.key,
      required this.onClose,
      required this.size,
      required this.contentListConfig});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PlayState playState = ref.watch(playWordStateProvider);
    bool introOff = ref.watch(introEnableProvider);
    return CustomMenu(menuItems: [
      CustomMenuItem(
        alignment: Alignment.centerLeft,
        icon: Icons.arrow_back,
        onTap: playState != PlayState.idle
            ? null
            : () async {
                ref.read(sttRecordProvider.notifier).clearWord();
                await ref.read(ttsSpeakerProvider.notifier).stop();
                onClose();
              },
      ),
      null,
      CustomMenuItem(
          alignment: Alignment.centerLeft,
          icon: introOff
              ? FontAwesomeIcons.volumeHigh
              : FontAwesomeIcons.volumeXmark,
          title: "Guide with Audio",
          scale: 0.8,
          onTap: () {
            ref.read(introEnableProvider.notifier).enable = !introOff;
          }),
      CustomMenuItem(
          alignment: Alignment.center,
          icon: Icons.report,
          scale: 0.8,
          onTap: playState != PlayState.idle
              ? null
              : () {
                  ScaffoldMessenger.of(context).showSnackBar((const SnackBar(
                    content: Text("if the word is not recognized correctly, "
                        "long press this button to report and "
                        "exclude from the list"),
                    behavior: SnackBarBehavior.floating,
                  )));
                },
          onLongPress: playState != PlayState.idle
              ? null
              : () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                      (const SnackBar(content: Text("Reporting this word"))));

                  await ref
                      .read(wordsProvider(contentListConfig.filename).notifier)
                      .reportCurrentWord();
                },
          title: 'Report')
    ]);
  }
}
