import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manage_content/manage_content.dart';

import '../../../custom_widgets/app_snackbar.dart';
import '../../../custom_widgets/custom_menu.dart';
import '../../../tts/stt_record.dart';
import '../../../tts/tts_speaker.dart';
import 'providers/state_provider.dart';

class TopMenu extends ConsumerWidget {
  const TopMenu({
    required this.onClose,
    required this.size,
    required this.contentListConfig,
    super.key,
  });
  final ContentListConfig contentListConfig;
  final Size size;
  final Function() onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playState = ref.watch(playWordStateProvider);
    final introOff = ref.watch(introEnableProvider);
    return CustomMenu(
      menuItems: [
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
          title: 'Guide with Audio',
          scale: 0.8,
          onTap: () {
            ref.read(introEnableProvider.notifier).enabled = !introOff;
          },
        ),
        CustomMenuItem(
          icon: Icons.report,
          scale: 0.8,
          onTap: playState != PlayState.idle
              ? null
              : () => AppSnackBar.show(
                  context,
                  'if the word is not recognized correctly, '
                  'long press this button to report and '
                  'exclude from the list'),
          onLongPress: playState != PlayState.idle
              ? null
              : () async {
                  AppSnackBar.show(context, 'Reporting this word');

                  await ref
                      .read(wordsProvider(contentListConfig.filename).notifier)
                      .reportCurrentWord();
                },
          title: 'Report',
        )
      ],
    );
  }
}
