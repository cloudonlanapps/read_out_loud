import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../settings_chapters/page.dart';

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
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            title: const TitleText("General"),
            subtitle: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: SubtitleText("App level settings"),
            ),
            tileColor: Colors.white,
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            title: const TitleText("Listener"),
            subtitle: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: SubtitleText("Configuration related to  listening "),
            ),
            tileColor: Colors.white,
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            title: const TitleText(" Player"),
            subtitle: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: SubtitleText("Configure Audio Player"),
            ),
            tileColor: Colors.white,
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            title: const TitleText(" Reset "),
            subtitle: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: SubtitleText("Reset all Progress and local data."),
            ),
            tileColor: Colors.white,
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
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
            title: const TitleText("Chapters"),
            subtitle: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: SubtitleText(
                  "Add/Remove chapters, edit existing chapters, reset progress etc..\n"),
            ),
            tileColor: Colors.white,
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  const TitleText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
      textAlign: TextAlign.start,
    );
  }
}

class SubtitleText extends StatelessWidget {
  final String text;
  const SubtitleText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.blueGrey, fontSize: 20),
      textAlign: TextAlign.start,
    );
  }
}
