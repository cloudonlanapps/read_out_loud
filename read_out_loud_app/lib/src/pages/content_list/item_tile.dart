import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ItemTile extends StatefulWidget {
  final String text;
  final Size size;

  final double _progress;
  final double radius;

  const ItemTile({
    super.key,
    required this.text,
    required this.size,
    double progress = 0.0,
    this.radius = 50,
  }) : _progress = progress;

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  Timer? _timer;

  clearProgress() async {
    ScaffoldMessenger.of(context).showSnackBar((SnackBar(
      content: Text("Progress cleared for '${widget.text}'"),
      behavior: SnackBarBehavior.floating,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar((const SnackBar(
              content: Text("Long Press for 5 sec to clear progress"),
              behavior: SnackBarBehavior.floating,
            )));
          },
          onPanCancel: () => _timer?.cancel(),
          onPanDown: (_) => {
            _timer = Timer(const Duration(seconds: 5), () {
              clearProgress();
            })
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.radius),
                  bottomLeft: Radius.circular(widget.radius)),
            ),
            width: 50,
            height: widget.size.height,
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
                            style: TextStyle(color: Colors.blue.shade800)))),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar((SnackBar(
              content: Text("Open '${widget.text}'"),
              behavior: SnackBarBehavior.floating,
            )));
          },
          child: SizedBox(
            width: widget.size.width - 100,
            height: widget.size.height,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 60,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.text,
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
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar((SnackBar(
              content: Text("Open '${widget.text}'"),
              behavior: SnackBarBehavior.floating,
            )));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(widget.radius),
                  bottomRight: Radius.circular(widget.radius)),
            ),
            width: 50,
            height: widget.size.height,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue.shade400,
            ),
          ),
        ),
      ],
    );
  }
}
