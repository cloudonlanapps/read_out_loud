import 'package:flutter/material.dart';
import 'package:manage_content/manage_content.dart';

import 'widgets/chapter_create.dart';
import 'widgets/chapter_update.dart';

class MainContent extends StatelessWidget {
  final Repository repository;

  final int? index;
  final Function() onClose;
  const MainContent({
    super.key,
    required this.repository,
    this.index,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      //margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 8),
      child: index == null
          ? ChapterCreate(
              repository: repository,
              onClose: onClose,
            )
          : FutureBuilder(
              future:
                  ContentStorage.hasAsset(repository.chapters[index!].filename),
              builder: (BuildContext build, AsyncSnapshot snapshot) {
                bool readOnly = !snapshot.hasData || snapshot.data as bool;

                return ChapterUpdate(
                    key: ObjectKey(repository.chapters[index!]),
                    wordsFilename: repository.chapters[index!].filename,
                    readOnly: readOnly,
                    onClose: onClose);
              },
            ),
    );
  }
}
