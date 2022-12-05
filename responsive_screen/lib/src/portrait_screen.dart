import 'package:flutter/material.dart';

import '../responsive_screen.dart';

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

  double get hTop => ResponsiveScreen.topHeight(topMenuBuilder != null);
  double get hBottom =>
      ResponsiveScreen.bottomHeight(bottomMenubuilder != null);
  double get hContent => ResponsiveScreen.contentHeight(
      size: size,
      isBottom: bottomMenubuilder != null,
      isTop: topMenuBuilder != null);

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
