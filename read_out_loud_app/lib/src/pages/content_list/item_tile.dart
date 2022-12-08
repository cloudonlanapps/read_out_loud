import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../custom_widgets/progress_bar.dart';
import 'progress_corner.dart';

class ItemTile extends ConsumerStatefulWidget {
  final Chapter chapter;
  final Size size;

  final double radius;

  final Function() onSelectItem;

  const ItemTile(
      {super.key,
      required this.chapter,
      required this.size,
      this.radius = 50,
      required this.onSelectItem});

  @override
  ConsumerState<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends ConsumerState<ItemTile> {
  double get pad => 4.0;
  double get widthMinusPad => widget.size.width - (2 * pad);
  double get heightMinusPad => widget.size.height - (2 * pad);
  Size get size => Size(widthMinusPad, heightMinusPad);

  @override
  Widget build(BuildContext context) {
    double progress = ref.watch(wordsProvider(widget.chapter.filename)
        .select((value) => value?.progress ?? 0.0));

    return Padding(
      padding: EdgeInsets.all(pad),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Stack(
          children: [
            ProgressBar(size: size, progress: progress),
            Row(
              children: [
                ProgressCorner(
                  chapter: widget.chapter,
                  size: Size(size.width, 50),
                  radius: widget.radius,
                ),
                GestureDetector(
                  onTap: () => widget.onSelectItem(),
                  child: SizedBox(
                    width: size.width - 100,
                    height: size.height,
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
                                child: Text(widget.chapter.title,
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
                  onTap: () => widget.onSelectItem(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(widget.radius),
                          bottomRight: Radius.circular(widget.radius)),
                    ),
                    width: 50,
                    height: size.height,
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
