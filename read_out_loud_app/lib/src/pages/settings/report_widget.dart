import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import 'main.dart';

class ReportWidget extends ConsumerWidget {
  const ReportWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String>? reportedWords = ref.watch(reportedWordsProvider);
    const textStyle = TextStyle(color: Colors.blueGrey, fontSize: 20);
    final length = reportedWords?.length ?? 0;
    return ListTile(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 8.0, left: 8, right: 8, bottom: 24),
                    child: TitleText("Reported Words"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 8, right: 8, bottom: 8),
                    child: Text(
                      reportedWords!.join(", "),
                      style: textStyle,
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 8),
                    child: Text(
                      "Copy and report to developer",
                      style: textStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 8, right: 8, bottom: 64),
                    child: Center(
                      child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.copy_outlined),
                          label: const Text("Copy")),
                    ),
                  )
                ],
              );
            });
      },
      contentPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        //<-- SEE HERE
        side: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      title: const TitleText("Report"),
      subtitle: (length == 0)
          ? const Text("There is nothing to report", style: textStyle)
          : Text.rich(TextSpan(children: [
              TextSpan(
                  text: "You have marked $length words as problematic. "
                      "You could report them to developer. ",
                  style: textStyle),
            ])),
      tileColor: Colors.white,
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}

/*

 return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(

          title: const TitleText("Report"),
          subtitle: 
    );
children: [
          if (length > 0) ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 8.0, left: 8, right: 8, bottom: 24),
                              child: TitleText("Reported Words"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8, right: 8, bottom: 64),
                              child: Text(
                                reportedWords!.join(", "),
                                style: textStyle,
                              ),
                            )
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.email_outlined),
                label: const Text(
                  "Report",
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ],
*/

