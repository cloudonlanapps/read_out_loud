import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../../custom_widgets/words_editor.dart';

class NewChapterEditor extends ConsumerWidget {
  final Repository repository;
  const NewChapterEditor({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const WordsEditor(
      title: "",
      existingWords: [],
    );
  }
}
