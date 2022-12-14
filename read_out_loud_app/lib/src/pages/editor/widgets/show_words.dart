import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';

class ShowWords extends ConsumerWidget {
  final String wordsFilename;
  final List<Word> deletedWords;
  final Function(Word word) onDeleteWord;
  final Function(Word word) onRestoreDeletedWord;
  final List<String> addedWords;
  final Function(String string) onDeleteString;

  final bool readonly;
  const ShowWords(
      {super.key,
      required this.wordsFilename,
      required this.readonly,
      required this.deletedWords,
      required this.addedWords,
      required this.onDeleteWord,
      required this.onDeleteString,
      required this.onRestoreDeletedWord});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAll = ref.watch(wordsProvider(wordsFilename));
    final words = wordsAll?.wordsIncludeReported
            .where((element) => !deletedWords.contains(element))
            .toList() ??
        [];

    if (words.isEmpty && addedWords.isEmpty && deletedWords.isEmpty) {
      return Center(
        child: Text("This is an empty list, add more words ",
            textAlign: TextAlign.center,
            style: TextStyles.fullPageText(context)),
      );
    }
    return Column(
      children: [
        WrapWithTitle(
          children: words
              .map((word) => CustomChip(
                  chipStyle: word.report
                      ? CustChipStyle.reported
                      : word.succeeded
                          ? CustChipStyle.succeeded
                          : CustChipStyle.normal,
                  label: word.original,
                  onTap: readonly || word.report
                      ? null
                      : () => onDeleteWord(word)))
              .toList(),
        ),
        if (addedWords.isNotEmpty) ...[
          const Divider(thickness: 1, height: 8),
          WrapWithTitle(
            title: "Added words",
            children: addedWords
                .map((string) => CustomChip(
                    chipStyle: CustChipStyle.added,
                    label: string,
                    onTap: readonly ? null : () => onDeleteString(string)))
                .toList(),
          ),
        ],
        if (deletedWords.isNotEmpty) ...[
          const Divider(thickness: 1, height: 8),
          WrapWithTitle(
            title: "Deleted Words",
            children: deletedWords
                .map((word) => CustomChip(
                      chipStyle: CustChipStyle.deleted,
                      label: word.original,
                      iconData: Icons.restart_alt_sharp,
                      onTap: readonly ? null : () => onRestoreDeletedWord(word),
                    ))
                .toList(),
          )
        ]
      ],
    );
  }
}

class CustomChip extends ConsumerWidget {
  final CustChipStyle chipStyle;
  final String label;
  final IconData? iconData;
  final Function()? onTap;

  const CustomChip(
      {super.key,
      required this.chipStyle,
      required this.label,
      this.iconData,
      this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: Theme.of(context).copyWith(
          chipTheme: AppChipTheme.of(context, chipStyles: chipStyle).data),
      child: Chip(
          label: Text(label),
          deleteIcon: Icon(iconData ?? Icons.close),
          onDeleted: onTap),
    );
  }
}

class WrapWithTitle extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const WrapWithTitle({super.key, required this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title!,
                  style: TextStyles.chapterTitle(context),
                )),
          ),
        Card(
            margin: const EdgeInsets.all(4.0),
            elevation: 4,
            child: SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: children,
                    )))),
      ],
    );
  }
}
