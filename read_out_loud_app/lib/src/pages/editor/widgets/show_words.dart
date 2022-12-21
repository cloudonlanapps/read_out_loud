import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';

import '../../../custom_widgets/custom_chip.dart';
import '../../../custom_widgets/titled_wrap.dart';

class ShowWords extends ConsumerWidget {
  const ShowWords({
    required this.wordsFilename,
    required this.readonly,
    required this.deletedWords,
    required this.addedWords,
    required this.onDeleteWord,
    required this.onDeleteString,
    required this.onRestoreDeletedWord,
    super.key,
  });
  final String wordsFilename;
  final List<Word> deletedWords;
  final Function(Word word) onDeleteWord;
  final Function(Word word) onRestoreDeletedWord;
  final List<String> addedWords;
  final Function(String string) onDeleteString;

  final bool readonly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAll = ref.watch(wordsProvider(wordsFilename));
    final words = wordsAll?.wordsIncludeReported
            .where((element) => !deletedWords.contains(element))
            .toList() ??
        [];

    if (words.isEmpty && addedWords.isEmpty && deletedWords.isEmpty) {
      return Center(
        child: Text(
          'This is an empty list, add more words ',
          textAlign: TextAlign.center,
          style: TextStyles.fullPageText(context),
        ),
      );
    }
    return Column(
      children: [
        TitledWrap(
          children: words
              .map(
                (word) => CustomChip(
                  chipStyle: word.report
                      ? CustChipStyle.reported
                      : word.succeeded
                          ? CustChipStyle.succeeded
                          : CustChipStyle.normal,
                  label: word.original,
                  onTap:
                      readonly || word.report ? null : () => onDeleteWord(word),
                ),
              )
              .toList(),
        ),
        if (addedWords.isNotEmpty) ...[
          const Divider(thickness: 1, height: 8),
          TitledWrap(
            title: 'Added words',
            children: addedWords
                .map(
                  (string) => CustomChip(
                    chipStyle: CustChipStyle.added,
                    label: string,
                    onTap: readonly ? null : () => onDeleteString(string),
                  ),
                )
                .toList(),
          ),
        ],
        if (deletedWords.isNotEmpty) ...[
          const Divider(thickness: 1, height: 8),
          TitledWrap(
            title: 'Deleted Words',
            children: deletedWords
                .map(
                  (word) => CustomChip(
                    chipStyle: CustChipStyle.deleted,
                    label: word.original,
                    iconData: Icons.restart_alt_sharp,
                    onTap: readonly ? null : () => onRestoreDeletedWord(word),
                  ),
                )
                .toList(),
          )
        ]
      ],
    );
  }
}
