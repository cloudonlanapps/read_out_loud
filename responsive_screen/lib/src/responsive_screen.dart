import 'package:flutter/material.dart';

import 'landscape_screen.dart';
import 'portrait_screen.dart';

class ResponsiveScreen extends StatelessWidget {
  final Widget Function(BuildContext context, Size size) contentBuilder;
  final Widget Function(BuildContext context, Size size)? topMenuBuilder;
  final Widget Function(BuildContext context, Size size)? bottomMenubuilder;

  const ResponsiveScreen({
    super.key,
    required this.contentBuilder,
    this.topMenuBuilder,
    this.bottomMenubuilder,
  });

  static double contentHeight(
      {required Size size, required bool isBottom, required bool isTop}) {
    return size.height - topHeight(isTop) - bottomHeight(isBottom);
  }

  static double topHeight(bool isTop) => isTop ? 65 : 0;
  static double bottomHeight(bool isBottom) => isBottom ? 65 : 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (size.height >= size.width) {
          return PortraitScreen(
            size: size,
            contentBuilder: contentBuilder,
            topMenuBuilder: topMenuBuilder,
            bottomMenubuilder: bottomMenubuilder,
          );
        } else {
          return LandscapeScreen(
            size: size,
            contentBuilder: contentBuilder,
            topMenuBuilder: topMenuBuilder,
            bottomMenubuilder: bottomMenubuilder,
          );
        }
      },
    );
  }
}
