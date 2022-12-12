import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:read_out_loud_app/src/pages/editor_view/widgets/chapter_update.dart';

class ChapterEditor extends ConsumerWidget {
  final Repository repository;
  final int index;
  const ChapterEditor(
      {super.key, required this.repository, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: isReadOnly(repository.chapters[index].filename),
      builder: (BuildContext build, AsyncSnapshot snapshot) {
        bool readOnly = !snapshot.hasData || snapshot.data as bool;

        return ChapterUpdate(
          key: ObjectKey(repository.chapters[index]),
          repository: repository,
          index: index,
          readOnly: readOnly,
        );
      },
    );
  }

  Future<bool> isReadOnly(filename) async =>
      await ContentStorage.hasAsset(filename);
}
