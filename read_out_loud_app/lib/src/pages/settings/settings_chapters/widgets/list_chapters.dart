import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';

import '../../../../custom_widgets/chapter_view.dart';
import '../../../editor/page.dart';

class ListChapters extends ConsumerWidget {
  const ListChapters({
    required this.repository,
    Key? key,
  }) : super(key: key);
  final Repository repository;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: repository.chapters.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: ContentStorage.hasAsset(repository.chapters[index].filename),
          builder: (context, snapshot) {
            final isAsset = !snapshot.hasData || (snapshot.data ?? false);
            return ChapterView(
              chapter: repository.chapters[index],
              onDelete: isAsset
                  ? null
                  : () {
                      ref
                          .read(repositoryProvider('index.json').notifier)
                          .removeChapter(
                            repository,
                            repository.chapters[index],
                          );
                    },
              onResetProgress: () {
                ref
                    .read(
                      wordsProvider(repository.chapters[index].filename)
                          .notifier,
                    )
                    .clearProgress();
              },
              onTap: () {
                context.pushNamed(
                  EditorPage().name,
                  queryParams: {'index': index.toString()},
                );
              },
            );
          },
        );
      },
    );
  }

  Future<bool> isAssetExists(String filename) async {
    return false;
  }
}
