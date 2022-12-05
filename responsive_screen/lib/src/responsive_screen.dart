import 'package:flutter/material.dart';

import 'landscape_screen.dart';
import 'portrait_screen.dart';

class ResponsiveScreen extends StatelessWidget {
  final Size size;
  final Widget Function(BuildContext context, Size size) contentBuilder;
  final Widget Function(BuildContext context, Size size)? topMenuBuilder;
  final Widget Function(BuildContext context, Size size)? bottomMenubuilder;

  const ResponsiveScreen({
    super.key,
    required this.size,
    required this.contentBuilder,
    this.topMenuBuilder,
    this.bottomMenubuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
