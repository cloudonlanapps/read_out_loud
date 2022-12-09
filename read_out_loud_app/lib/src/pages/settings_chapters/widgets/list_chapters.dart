import 'package:flutter/material.dart';
import 'package:manage_content/manage_content.dart';

import 'chapter_view.dart';

class ListChapters extends StatefulWidget {
  final Repository repository;
  const ListChapters({
    Key? key,
    required this.repository,
  }) : super(key: key);

  @override
  State<ListChapters> createState() => _ListChaptersState();
}

class _ListChaptersState extends State<ListChapters> {
  int currIndex = -1;

  onExpansion(int index) {
    setState(() {
      currIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: ValueKey(currIndex),
        itemCount: widget.repository.chapters.length,
        itemBuilder: (BuildContext context, int index) {
          return ChapterView(
              chapter: widget.repository.chapters[index],
              myIndex: index,
              selectedIndex: currIndex,
              onExpansion: onExpansion);
        });
  }
}
