import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manage_content/manage_content.dart';

class ChapterView extends ConsumerWidget {
  final textStyle = const TextStyle(color: Colors.blueGrey, fontSize: 20);

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
            title: TitleText(chapter.title),
            children: [
              if (!nothingToShow) ...[
                if (words.successCount > 0) ...[
                  const Divider(
                    thickness: 2,
                  ),
                  Text(
                      "Can read ${words.successCount} of ${words.totalCount} words",
                      style: textStyle.copyWith(color: Colors.green)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Clear Progress",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ] else
                  Text(
                      "There are ${words.totalCount} words to learn in this chapter",
                      style: textStyle),
                const Divider(
                  thickness: 2,
                ),
                if (words.reportCount > 0) ...[
                  Text("Have marked ${words.reportCount} words as problematic",
                      style: textStyle.copyWith(color: Colors.redAccent)),
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
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.0,
                                        left: 8,
                                        right: 8,
                                        bottom: 24),
                                    child: TitleText("Reported Words"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 8,
                                        right: 8,
                                        bottom: 64),
                                    child: Text(
                                      words.reported.join(", "),
                                      style: textStyle,
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

class TitleText extends StatelessWidget {
  final String text;
  const TitleText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 30),
      textAlign: TextAlign.start,
    );
  }
}
