import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:read_out_loud_app/src/tts/stt_record.dart';

import '../../../custom_widgets/custom_menu.dart';
import 'providers/state_provider.dart';

class BottomMenu extends ConsumerWidget {
  const BottomMenu({
    required this.contentListConfig,
    required this.size,
    super.key,
  });
  final Size size;
  final ContentListConfig contentListConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(wordsProvider(contentListConfig.filename));
    final playState = ref.watch(playWordStateProvider);
    if (words == null) {
      return Container();
    }

    return CustomMenu(
      menuItems: [
        if (words.isFirst)
          null
        else
          CustomMenuItem(
            alignment: Alignment.bottomCenter,
            icon: Icons.arrow_circle_left,
            onTap: playState != PlayState.idle
                ? null
                : () async {
                    ref.read(sttRecordProvider.notifier).clearWord();
                    await ref
                        .read(
                          wordsProvider(contentListConfig.filename).notifier,
                        )
                        .prev();
                  },
            title: 'Prev',
          ),
        /* if ([PlayState.intro, PlayState.reading].contains(playState))
        CustomMenuItem(
            alignment: Alignment.bottomCenter,
            icon: Icons.stop,
            onTap: () async {
              await ref.watch(ttsSpeakerProvider.notifier).stop();
            },
            title: 'Stop')
      else */
        null,
        if (words.isLast)
          null
        else
          CustomMenuItem(
            alignment: Alignment.bottomCenter,
            icon: Icons.arrow_circle_right,
            onTap: playState != PlayState.idle
                ? null
                : () async {
                    ref.read(sttRecordProvider.notifier).clearWord();
                    await ref
                        .read(
                          wordsProvider(contentListConfig.filename).notifier,
                        )
                        .next();
                  },
            title: 'Next',
          )
      ],
    );
  }
}
