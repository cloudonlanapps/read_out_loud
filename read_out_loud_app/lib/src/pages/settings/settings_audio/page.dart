import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_out_loud_app/src/tts/tts_speaker.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import '../../../custom_widgets/title_menu.dart';
import '../../main/page.dart';
import 'main.dart';

class AdvancedSettingsPage implements AppRoute {
  @override
  String get name => "advanced_settings";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (BuildContext context, GoRouterState state) {
        return PageView(
          filename: 'index.json',
          onClose: () {
            try {
              context.pop();
            } catch (e) {
              context.goNamed(MainPage().name);
            }
          },
        );
      };
}

class PageView extends ConsumerWidget {
  final String? filename;
  final Function() onClose;

  const PageView({
    super.key,
    required this.filename,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScreen(
      contentBuilder: (context, size) =>
          MainContent(filename: filename, size: size),
      topMenuBuilder: (context, size) => TitleMenu(
        action: () async {
          await ref.read(ttsSpeakerProvider.notifier).stop();
          onClose();
        },
        size: size,
        title: "Audio Settings",
      ),
    );
  }
}
