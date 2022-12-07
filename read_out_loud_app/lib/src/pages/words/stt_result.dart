import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tts/stt_record.dart';

class STTResult extends ConsumerWidget {
  const STTResult({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    STTRecord sttRecord = ref.watch(sttRecordProvider);
    if (sttRecord.lastWords.isEmpty) return Container();
    final spokenWords = sttRecord.lastWords.split(' ');
    final lastWord = spokenWords.last;
    final before = spokenWords.sublist(0, spokenWords.length - 1);
    return Text.rich(
      TextSpan(children: [
        const TextSpan(text: 'Did you say "'),
        TextSpan(text: before.join(' ')),
        const TextSpan(text: ' '),
        TextSpan(
            text: lastWord,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: '"?'),
      ]),
      style: const TextStyle(color: Colors.white, fontSize: 40),
      textAlign: TextAlign.center,
    );
  }
}
