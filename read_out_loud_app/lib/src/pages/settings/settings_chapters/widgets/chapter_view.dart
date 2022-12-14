import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manage_content/manage_content.dart';

import '../../../../custom_widgets/settings_menu_button.dart';

class ChapterView extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChapterViewState();
}

class _ChapterViewState extends ConsumerState<ChapterView> {
  ActionPane get actionPane => ActionPane(
        motion: const BehindMotion(),
        children: [
          if (widget.onResetProgress != null)
            SlidableAction(
              onPressed: (ctx) {
                confirmBeforeCall(context,
                    message:
                        "Are you sure you want to reset chapter titled '${widget.chapter.title}'. This will remove all your progress",
                    action: widget.onResetProgress!);
              },
              icon: Icons.restore_page,
              label: 'Reset',
              foregroundColor: Colors.amber.shade300,
              backgroundColor: Colors.transparent,
            ),
          if (widget.onDelete != null)
            SlidableAction(
              onPressed: (ctx) async {
                confirmBeforeCall(context,
                    message:
                        "Are you sure you want to delete chapter titled '${widget.chapter.title}'",
                    action: widget.onDelete!);
              },
              icon: Icons.delete,
              foregroundColor: Colors.red.shade300,
              label: 'Delete',
              backgroundColor: Colors.transparent,
            ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final Words? words = ref.watch(wordsProvider(widget.chapter.filename));

    return Slidable(
        endActionPane: ((words == null) ||
                (widget.onResetProgress == null && widget.onDelete == null))
            ? null
            : actionPane,
        key: ObjectKey(widget.chapter),
        child: SettingsMenuButton(
          title: widget.chapter.title,
          onTap: widget.onEdit,
          subTitle: (words == null)
              ? "This chapter is missing"
              : words.words.isEmpty
                  ? "This chapter is empty"
                  : (words.successCount > 0)
                      ? "Can read ${words.successCount} of ${words.totalCount} words"
                      : "${words.totalCount} words",
        ));
  }

  confirmBeforeCall(BuildContext context,
      {required String message, required Function() action}) {
    showOkCancelAlertDialog(
      context: context,
      message: message,
      okLabel: "Yes",
      cancelLabel: "No",
    ).then((result) {
      if (result == OkCancelResult.ok) {
        action();
      }
    });
  }
}
