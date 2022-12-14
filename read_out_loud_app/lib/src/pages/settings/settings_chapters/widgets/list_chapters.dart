import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';

import '../../../editor/page.dart';
import 'chapter_view.dart';

class ListChapters extends ConsumerWidget {
  final Repository repository;
  const ListChapters({
    Key? key,
    required this.repository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: repository.chapters.length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder(
            future:
                ContentStorage.hasAsset(repository.chapters[index].filename),
            builder: ((context, snapshot) {
              final bool isAsset = !snapshot.hasData || (snapshot.data as bool);
              return ChapterView(
                  chapter: repository.chapters[index],
                  onDelete: isAsset
                      ? null
                      : () {
                          ref
                              .read(repositoryProvider("index.json").notifier)
                              .removeChapter(
                                  repository, repository.chapters[index]);
                        },
                  onResetProgress: () {
                    ref
                        .read(wordsProvider(repository.chapters[index].filename)
                            .notifier)
                        .clearProgress();
                  },
                  onEdit: () {
                    context.pushNamed(EditorPage().name,
                        queryParams: {"index": index.toString()});
                  });
            }),
          );
        });
  }

  Future<bool> isAssetExists(String filename) async {
    return false;
  }
}
