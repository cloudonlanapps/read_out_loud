import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../../custom_widgets/progress_bar.dart';
import 'progress_corner.dart';

class ChapterView extends ConsumerWidget {
  final Chapter chapter;
  final Size size;

  final double radius;

  final Function() onSelectItem;

  const ChapterView(
      {super.key,
      required this.chapter,
      required this.size,
      this.radius = 50,
      required this.onSelectItem});

  double get pad => 4.0;
  double get widthMinusPad => size.width - (2 * pad);
  double get heightMinusPad => size.height - (2 * pad);
  Size get tileSize => Size(widthMinusPad, heightMinusPad);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double progress = ref.watch(wordsProvider(chapter.filename)
        .select((value) => value?.progress ?? 0.0));

    return Padding(
      padding: EdgeInsets.all(pad),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Stack(
          children: [
            ProgressBar(size: tileSize, progress: progress),
            Row(
              children: [
                ProgressCorner(
                  chapter: chapter,
                  size: Size(
                    50,
                    tileSize.height,
                  ),
                  radius: radius,
                ),
                GestureDetector(
                  onTap: () => onSelectItem(),
                  child: SizedBox(
                    width: tileSize.width - 100,
                    height: tileSize.height,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 60,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(chapter.title,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 30, color: Colors.black)),
                              ),
                            ),
                          ),
                          // const Expanded(flex: 40, child: Text("Not attempted yet"))
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => onSelectItem(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(radius),
                          bottomRight: Radius.circular(radius)),
                    ),
                    width: 50,
                    height: tileSize.height,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blue.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
