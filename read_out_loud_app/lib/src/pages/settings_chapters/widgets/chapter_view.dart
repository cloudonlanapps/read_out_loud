import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manage_content/manage_content.dart';

class ChapterView extends ConsumerWidget {
  final Chapter chapter;

  final int myIndex;
  final int selectedIndex;
  final Function(int selectIndex) onExpansion;
  final bool editable;

  const ChapterView({
    Key? key,
    required this.chapter,
    required this.myIndex,
    required this.selectedIndex,
    required this.onExpansion,
    required this.editable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Words? words = ref.watch(wordsProvider(chapter.filename));
    bool nothingToShow = (words == null || words.words.isEmpty);

    return Slidable(
      endActionPane: (nothingToShow || !editable)
          ? null
          : ActionPane(
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  onPressed: (ctx) {},
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (ctx) {},
                  icon: Icons.delete,
                  foregroundColor: Colors.red.shade300,
                  label: 'Delete',
                ),
              ],
            ),
      child: Card(
        color: nothingToShow ? Colors.grey : null,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 8),
          child: ExpansionTile(
            key: const ValueKey("chapter.title"),
            initiallyExpanded: myIndex == selectedIndex,
            onExpansionChanged: (bool change) => nothingToShow
                ? onExpansion(selectedIndex)
                : onExpansion(change ? myIndex : -1),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: Text(chapter.title,
                style: Theme.of(context).textTheme.bodyLarge),
            children: [
              if (!nothingToShow) ...[
                if (words.successCount > 0) ...[
                  const Divider(
                    thickness: 2,
                  ),
                  Text(
                      "Can read ${words.successCount} of ${words.totalCount} words",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.green)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        await ref
                            .read(wordsProvider(chapter.filename).notifier)
                            .clearProgress();
                      },
                      child: const Text(
                        "Clear Progress",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ] else
                  Text(
                      "There are ${words.totalCount} words to learn in this chapter",
                      style: Theme.of(context).textTheme.bodyMedium!),
                const Divider(
                  thickness: 2,
                ),
                if (words.reportCount > 0) ...[
                  Text("Have marked ${words.reportCount} words as problematic",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.redAccent)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 8,
                                        right: 8,
                                        bottom: 24),
                                    child: Text(
                                      "Reported Words",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 8,
                                        right: 8,
                                        bottom: 64),
                                    child: Text(
                                      words.reported.join(", "),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!,
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      child: const Text(
                        "View",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                ],
              ]
            ],
          ),
        ),
      ),
    );
  }
}
