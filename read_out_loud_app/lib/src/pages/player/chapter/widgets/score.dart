import 'package:flutter/material.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';

class Score extends StatelessWidget {
  const Score({
    required this.words,
    super.key,
  });
  final Words words;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Score: '),
          if (words.successCount > 0)
            TextSpan(text: '${words.successCount} / ${words.words.length}')
          else
            const TextSpan(text: '___'),
        ],
      ),
      style: TextStyles.chapterContent(context),
    );
  }
}
