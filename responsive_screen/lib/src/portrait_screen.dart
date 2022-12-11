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
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (topMenuBuilder != null)
          SizedBox.fromSize(
              size: Size(size.width, hTop),
              child: topMenuBuilder!(context, Size(size.width, hTop))),
        SizedBox.fromSize(
            size: Size(size.width, hContent),
            child: contentBuilder(context, Size(size.width, hContent))),
        if (bottomMenubuilder != null)
          SizedBox.fromSize(
              size: Size(size.width, hBottom),
              child: bottomMenubuilder!(context, Size(size.width, hBottom))),
      ],
    );
  }
}
