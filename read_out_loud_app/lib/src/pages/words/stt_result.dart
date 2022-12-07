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
    return Column(
      children: <Widget>[
        const Center(
          child: Text(
            'Recognized Words',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent, //Theme.of(context).selectedRowColor,
            child: Center(
              child: Text(
                sttRecord.lastWords.isNotEmpty ? sttRecord.lastWords : " ??? ",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
