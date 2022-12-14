import 'package:flutter/material.dart';
import 'package:read_out_loud_app/src/custom_widgets/custom_chip.dart';
import 'package:read_out_loud_app/src/custom_widgets/titled_wrap.dart';
import 'package:services/services.dart';

class ReportPopup extends StatelessWidget {
  final List<String> reportedWords;
  final bool allowReport;
  const ReportPopup({
    super.key,
    required this.reportedWords,
    this.allowReport = true,
  });

  @override
  Widget build(BuildContext context) {
    final text = reportedWords.join(', ');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          TitledWrap(
              title: "Reported Words",
              children: reportedWords
                  .map<Widget>((String word) =>
                      CustomChip(chipStyle: CustChipStyle.normal, label: word))
                  .toList()),
          if (allowReport) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Copy and report to developer",
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Center(
                child: ElevatedButton.icon(
                    onPressed: () async {
                      ClipboardManager.copy(text);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.copy_sharp),
                    label: const Text("Copy")),
              ),
            )
          ]
        ],
      ),
    );
  }
}
