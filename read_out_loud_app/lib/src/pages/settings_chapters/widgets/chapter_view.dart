import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manage_content/manage_content.dart';

class ChapterView extends StatelessWidget {
  final Chapter chapter;

  final int myIndex;
  final int selectedIndex;
  final Function(int selectIndex) onExpansion;

  const ChapterView({
    Key? key,
    required this.chapter,
    required this.myIndex,
    required this.selectedIndex,
    required this.onExpansion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
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
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 8),
          child: ExpansionTile(
            initiallyExpanded: myIndex == selectedIndex,
            onExpansionChanged: (bool change) =>
                onExpansion(change ? myIndex : -1),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: TitleText(chapter.title),
            children: [
              const Divider(
                thickness: 2,
              ),
              const SubtitleText("Can read x/y words"),
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
              const Divider(
                thickness: 2,
              ),
              const SubtitleText("Have marked N words as problematic"),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.email_outlined),
                  label: const Text(
                    "Send",
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
              ),
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

class SubtitleText extends StatelessWidget {
  final String text;
  const SubtitleText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.blueGrey, fontSize: 20),
      textAlign: TextAlign.start,
    );
  }
}
