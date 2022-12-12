import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import 'widgets/chapter_create.dart';
import 'widgets/existing_chapter.dart';

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
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              margin:
                  const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 8),
              child: index == null
                  ? ChapterCreate(
                      repository: repository,
                    )
                  : ChapterEditor(
                      repository: repository,
                      index: index!,
                    ),
            ),
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator());
  }
}
