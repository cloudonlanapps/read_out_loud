import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tts/stt_record.dart';

extension Highlight on String {
  List<String> highlight(String hightlightWord) {
    if ((hightlightWord.isEmpty) || isEmpty) {
      return [this];
    } else {
      List<String> words = split(' ');
      final index = words.lastIndexWhere((element) =>
          element.toLowerCase().contains(hightlightWord.toLowerCase()));
      if (index < 0) return [this];
      var before = words.sublist(0, index).join(' ');
      if (before.isNotEmpty) {
        before = '$before ';
      }
      var after = words.sublist(index + 1).join('');
      if (after.isNotEmpty) {
        after = ' $after';
      }
      return [before, hightlightWord, after];
    }
  }
}

class STTResult extends ConsumerWidget {
  final String highlight;
  TextStyle get normalStyle =>
      const TextStyle(color: Colors.white, fontSize: 40);
  TextStyle get highlightStyle => normalStyle.copyWith(
      fontWeight: FontWeight.bold, color: Colors.red.shade400);
  const STTResult({
    this.highlight = '',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    STTRecord sttRecord = ref.watch(sttRecordProvider);
    if (sttRecord.lastWords.isEmpty) return Container();
    List<String> textBlocks =
        sttRecord.lastWords.toLowerCase().highlight(highlight);
    {
      return Text.rich(TextSpan(children: [
        TextSpan(text: "You said: ", style: normalStyle),
        if (textBlocks.length == 1)
          TextSpan(text: textBlocks[0], style: normalStyle)
        else ...[
          TextSpan(text: textBlocks[0], style: normalStyle),
          TextSpan(text: textBlocks[1], style: highlightStyle),
          TextSpan(text: textBlocks[2], style: normalStyle)
        ]
      ]));
    }
  }
}
