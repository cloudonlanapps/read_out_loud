import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manage_content/manage_content.dart';

import 'progress_bar.dart';
import 'settings_menu_button.dart';

class ChapterView extends ConsumerStatefulWidget {
  final Chapter chapter;
  final Size? size;

  final Function()? onDelete;
  final Function()? onTap;
  final Function()? onResetProgress;

  const ChapterView({
    Key? key,
    required this.chapter,
    this.size,
    this.onDelete,
    this.onTap,
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
    double? progress = words?.progress;
    return Slidable(
        endActionPane: ((words == null) ||
                (widget.onResetProgress == null && widget.onDelete == null))
            ? null
            : actionPane,
        key: ObjectKey(widget.chapter),
        child: Card(
          color: widget.onTap == null ? Colors.grey : null,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.only(
            bottom: 8.0,
            left: 8,
            right: 8,
          ),
          child: Stack(
            children: [
              if (widget.size != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ProgressBar(
                      size: Size(widget.size!.width - 16, 16),
                      progress: progress ?? 0),
                ),
              SettingsMenuButton(
                title: widget.chapter.title,
                onTap: widget.onTap,
                subTitle: (words == null)
                    ? "This chapter is missing"
                    : words.words.isEmpty
                        ? "This chapter is empty"
                        : (words.successCount > 0)
                            ? "Can read ${words.successCount} of ${words.totalCount} words"
                            : "${words.totalCount} words",
              ),
            ],
          ),
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
