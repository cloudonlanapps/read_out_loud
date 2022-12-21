import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';

class ReportWidget extends ConsumerWidget {
  const ReportWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportedWords = ref.watch(reportedWordsProvider);

    final length = reportedWords?.length ?? 0;
    return ListTile(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: 24,
                  ),
                  child: Text(
                    'Reported Words',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: Text(
                    reportedWords!.join(', '),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  child: Text(
                    'Copy and report to developer',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 8,
                    right: 8,
                    bottom: 64,
                  ),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await ClipboardManager.copy(reportedWords.join(', '))
                            .then((value) => Navigator.pop(context));
                      },
                      icon: const Icon(Icons.copy_outlined),
                      label: const Text('Copy'),
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
      contentPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        //<-- SEE HERE
        side: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text('Report', style: Theme.of(context).textTheme.bodyLarge),
      subtitle: (length == 0)
          ? Text(
              'There is nothing to report',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          : Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'You have marked $length words as problematic. '
                        'You could report them to developer. ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
      tileColor: Colors.white,
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
