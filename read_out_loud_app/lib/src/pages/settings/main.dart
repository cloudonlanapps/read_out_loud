import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_out_loud_app/src/pages/advanced_settings/page.dart';

import '../settings_chapters/page.dart';
import 'report_widget.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final String? filename;
  const MainContent({super.key, required this.filename, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            onTap: () => context.goNamed(SettingsChapterPage().name),
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            title:
                Text("Chapters", style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Add/Remove chapters, edit existing chapters, reset progress etc..\n",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            tileColor: Colors.white,
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: ReportWidget(),
        ),
        Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
          child: ListTile(
            onTap: () => context.goNamed(AdvancedSettingsPage().name),
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Advanced Settings",
                style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Expert level settings",
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            tileColor: Colors.white,
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    );
  }
}
