import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';

import '../../../custom_widgets/settings_menu_button.dart';
import '../settings_about/page.dart';
import '../settings_audio/page.dart';
import '../settings_chapters/page.dart';
import '../../../custom_widgets/report_popup.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final String? filename;
  const MainContent({super.key, required this.filename, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String>? reportedWords = ref.watch(reportedWordsProvider);
    final length = reportedWords?.length ?? 0;
    return SingleChildScrollView(
      child: Column(
        children: [
          SettingsMenuButton(
            title: "Chapters",
            subTitle:
                "Add/Remove chapters, edit existing chapters, reset progress etc.",
            onTap: () => context.pushNamed(SettingsChapterPage().name),
          ),
          if (length > 0)
            SettingsMenuButton(
              title: "Report",
              subTitle: (length == 0)
                  ? "There is nothing to report"
                  : "You have marked $length words as problematic. "
                      "You could report them to developer. ",
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return ReportPopup(reportedWords: reportedWords!);
                    });
              },
            ),
          SettingsMenuButton(
            title: "Audio Settings",
            subTitle: "Expert level settings",
            onTap: () => context.pushNamed(AdvancedSettingsPage().name),
          ),
          SettingsMenuButton(
            title: "About",
            subTitle: "About this app, options to backup, restore, reset etc",
            onTap: () => context.pushNamed(SettingsAboutPage().name),
          )
        ],
      ),
    );
  }
}
