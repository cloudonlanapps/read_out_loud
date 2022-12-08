import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../custom_widgets/custom_menu.dart';
import '../../tts/stt_record.dart';
import 'state_provider.dart';

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

    return CustomMenu(menuItems: [
      playState != PlayState.idle
          ? null
          : CustomMenuItem(
              alignment: Alignment.centerLeft,
              icon: Icons.arrow_back,
              onTap: () {
                ref.read(sttRecordProvider.notifier).clearWord();
                onClose();
              },
            ),
      null,
      null,
      if (playState == PlayState.idle)
        CustomMenuItem(
            alignment: Alignment.center,
            icon: Icons.report,
            scale: 0.8,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar((const SnackBar(
                content: Text("if the word is not recognized correctly, "
                    "long press this button to report and "
                    "exclude from the list"),
                behavior: SnackBarBehavior.floating,
              )));
            },
            onLongPress: () async {
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
