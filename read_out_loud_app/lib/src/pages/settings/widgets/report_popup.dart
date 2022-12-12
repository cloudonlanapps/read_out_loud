import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/clipboard/clipboard.dart';

class ReportPopup extends ConsumerWidget {
  final List<String> reportedWords;
  final bool allowReport;
  const ReportPopup({
    super.key,
    required this.reportedWords,
    this.allowReport = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = reportedWords.join(', ');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text("Reported Words",
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ),
          if (allowReport) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Copy and report to developer",
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: Center(
                child: ElevatedButton.icon(
                    onPressed: () async {
                      ClipboardManager.copy(text);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.copy_outlined),
                    label: const Text("Copy")),
              ),
            )
          ]
        ],
      ),
    );
  }
}
