import 'package:flutter/material.dart';

class PortraitScreen extends StatelessWidget {
  final Size size;
  final Widget Function(BuildContext context, Size size) contentBuilder;
  final Widget Function(BuildContext context, Size size)? topMenuBuilder;
  final Widget Function(BuildContext context, Size size)? bottomMenubuilder;
  const PortraitScreen({
    super.key,
    required this.size,
    required this.contentBuilder,
    this.topMenuBuilder,
    this.bottomMenubuilder,
  });

  double get hTop => topMenuBuilder == null ? 0 : 50;
  double get hBottom => bottomMenubuilder == null ? 0 : 50;
  double get hContent => size.height - hTop - hBottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (topMenuBuilder != null)
            topMenuBuilder!(context, Size(size.width, hTop)),
          Flexible(child: contentBuilder(context, Size(size.width, hContent))),
          if (bottomMenubuilder != null)
            bottomMenubuilder!(context, Size(size.width, hBottom)),
        ],
      ),
    );
  }
}
