import 'dart:math';

import 'package:flutter/material.dart';
import 'package:manage_content/manage_content.dart';

import '../../custom_widgets/progress_bar.dart';

class ItemTile extends StatefulWidget {
  final Chapter chapter;
  final Size size;

  final double _progress;
  final double radius;

  final Function() onSelectItem;

  const ItemTile(
      {super.key,
      required this.chapter,
      required this.size,
      double progress = 0.0,
      this.radius = 50,
      required this.onSelectItem})
      : _progress = progress;

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  clearProgress() async {
    ScaffoldMessenger.of(context).showSnackBar((SnackBar(
      content: Text("Progress cleared for '${widget.chapter.title}'"),
      behavior: SnackBarBehavior.floating,
    )));
  }

  double get pad => 4.0;
  double get widthMinusPad => widget.size.width - (2 * pad);
  double get heightMinusPad => widget.size.height - (2 * pad);
  Size get size => Size(widthMinusPad, heightMinusPad);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(pad),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Stack(
          children: [
            ProgressBar(size: size, progress: widget._progress),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(widget.radius),
                        bottomLeft: Radius.circular(widget.radius)),
                  ),
                  width: 50,
                  height: size.height,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Transform.rotate(
                          angle: -pi / 6.0,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                  (widget._progress < 0.05)
                                      ? "new"
                                      : "${(widget._progress * 100).toInt()}%",
                                  style:
                                      TextStyle(color: Colors.blue.shade800)))),
                    ),
                  ),
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
