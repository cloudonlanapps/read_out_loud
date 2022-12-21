import 'package:flutter/material.dart';
import 'package:manage_content/manage_content.dart';

import 'widgets/chapter_create.dart';
import 'widgets/chapter_update.dart';

class MainContent extends StatelessWidget {
  const MainContent({
    required this.repository,
    required this.onClose,
    this.index,
    super.key,
  });
  final Repository repository;

  final int? index;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      //elevation: 0,
      //color: Theme.of(context).colorScheme.surface,
      /* shape: RoundedRectangleBorder(
        //side: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(5),
      ), */
      //margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 8),
      child: index == null
          ? ChapterCreate(
              repository: repository,
              onClose: onClose,
            )
          : FutureBuilder(
              future:
                  ContentStorage.hasAsset(repository.chapters[index!].filename),
              builder: (build, snapshot) {
                final readOnly = !snapshot.hasData || (snapshot.data ?? false);

                return ChapterUpdate(
                  key: ObjectKey(repository.chapters[index!]),
                  wordsFilename: repository.chapters[index!].filename,
                  readOnly: readOnly,
                  onClose: onClose,
                );
              },
            ),
    );
  }
}
