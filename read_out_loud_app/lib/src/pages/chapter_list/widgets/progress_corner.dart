import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

class ProgressCorner extends ConsumerStatefulWidget {
  final Chapter chapter;
  final Size size;

  final double radius;
  const ProgressCorner(
      {super.key,
      required this.chapter,
      required this.size,
      required this.radius});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProgressState();
}

class _ProgressState extends ConsumerState<ProgressCorner> {
  Timer? _timer;

  clearProgress() async {
    await ref
        .read(wordsProvider(widget.chapter.filename).notifier)
        .clearProgress();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
        content: Text("Progress cleared for '${widget.chapter.title}'"),
        behavior: SnackBarBehavior.floating,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    double? progress = ref.watch(wordsProvider(widget.chapter.filename)
        .select((value) => value?.progress));
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          (const SnackBar(
            content: Text("Long Press for 5 sec to clear progress"),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          )),
        );
      },
      onPanCancel: () {
        _timer?.cancel();
      },
      onPanDown: (_) async {
        int duration = 5;

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          duration = duration - 1;
          if (duration == 0) {
            clearProgress();
            timer.cancel();
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar((SnackBar(
              content: Text("continue pressing for another $duration seconds"),
              behavior: SnackBarBehavior.floating,
            )));
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.radius),
              bottomLeft: Radius.circular(widget.radius)),
        ),
        width: widget.size.width,
        height: widget.size.height,
        child: (progress == null)
            ? null
            : FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Transform.rotate(
                      angle: -pi / 6.0,
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                              (progress < 0.05)
                                  ? "new"
                                  : "${(progress * 100).toInt()}%",
                              style: TextStyle(color: Colors.blue.shade800)))),
                ),
              ),
      ),
    );
  }
}
