import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manage_content/manage_content.dart';

import '../../../custom_widgets/settings_menu_button.dart';

class ChapterView extends ConsumerWidget {
  final Chapter chapter;

  final Function()? onDelete;
  final Function()? onEdit;
  final Function()? onResetProgress;

  const ChapterView({
    Key? key,
    required this.chapter,
    this.onDelete,
    this.onEdit,
    this.onResetProgress,
  }) : super(key: key);
  ActionPane get actionPane => ActionPane(
        motion: const BehindMotion(),
        children: [
          if (onResetProgress != null)
            SlidableAction(
              onPressed: (ctx) => onResetProgress?.call(),
              icon: Icons.restore_page,
              label: 'Reset Progress',
            ),
          if (onDelete != null)
            SlidableAction(
              onPressed: (ctx) => onDelete?.call(),
              icon: Icons.delete,
              foregroundColor: Colors.red.shade300,
              label: 'Delete',
            ),
        ],
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Words? words = ref.watch(wordsProvider(chapter.filename));

    return Slidable(
        endActionPane:
            ((words == null) || (onResetProgress == null && onDelete == null))
                ? null
                : actionPane,
        key: ObjectKey(chapter),
        child: SettingsMenuButton(
          title: chapter.title,
          onTap: onEdit,
          subTitle: (words == null)
              ? "This chapter is missing"
              : words.words.isEmpty
                  ? "This chapter is empty"
                  : (words.successCount > 0)
                      ? "Can read ${words.successCount} of ${words.totalCount} words"
                      : "${words.totalCount} words",
        ));
  }
}
