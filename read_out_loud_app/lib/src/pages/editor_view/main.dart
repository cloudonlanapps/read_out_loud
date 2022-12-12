import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import 'widgets/existing_chapter.dart';
import 'widgets/new_chapter.dart';

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
        data: (Repository repository) => _Editor(
            repository: repository, index: repository.isEmpty ? null : index),
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator());
  }
}

class _Editor extends ConsumerWidget {
  final Repository repository;
  final int? index;
  const _Editor({required this.repository, this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(bottom: 16.0, left: 8, right: 8, top: 8),
      child: index == null
          ? NewChapterEditor(
              repository: repository,
            )
          : ChapterEditor(
              repository: repository,
              index: index!,
            ),
    );
  }
}
