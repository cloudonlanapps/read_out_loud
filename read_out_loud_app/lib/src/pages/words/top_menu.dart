import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/custom_menu.dart';
import '../../tts/stt_record.dart';
import 'state_provider.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final Function() onClose;
  const TopMenu({super.key, required this.onClose, required this.size});

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
    ]);
  }
}
