import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import 'widgets/chapter_create.dart';
import 'widgets/chapter_update.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final String filename;
  final int? index;
  const MainContent({
    super.key,
    required this.filename,
    this.index,
    required this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(repositoryProvider(filename));

    return asyncValue.when(
        data: (Repository repository) => Card(
              //color: Colors.transparent,
              shape: const RoundedRectangleBorder(
                  //side: const BorderSide(width: 2),
                  // borderRadius: BorderRadius.circular(20),
                  ),
              margin: EdgeInsets.zero,
              child: index == null
                  ? ChapterCreate(
                      repository: repository,
                    )
                  : FutureBuilder(
                      future: ContentStorage.hasAsset(
                          repository.chapters[index!].filename),
                      builder: (BuildContext build, AsyncSnapshot snapshot) {
                        bool readOnly =
                            !snapshot.hasData || snapshot.data as bool;

                        return ChapterUpdate(
                          key: ObjectKey(repository.chapters[index!]),
                          wordsFilename: repository.chapters[index!].filename,
                          readOnly: readOnly,
                        );
                      },
                    ),
            ),
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator());
  }
}
