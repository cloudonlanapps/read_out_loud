import 'package:flutter/material.dart';

import 'portrait_screen.dart';

class LandscapeScreen extends StatelessWidget {
  final Size size;
  final Widget Function(BuildContext context, Size size) contentBuilder;
  final Widget Function(BuildContext context, Size size)? topMenuBuilder;
  final Widget Function(BuildContext context, Size size)? bottomMenubuilder;
  const LandscapeScreen({
    super.key,
    required this.size,
    required this.contentBuilder,
    this.topMenuBuilder,
    this.bottomMenubuilder,
  });

  @override
  Widget build(BuildContext context) {
    return PortraitScreen(
      contentBuilder: contentBuilder,
      topMenuBuilder: topMenuBuilder,
      bottomMenubuilder: bottomMenubuilder,
      size: size,
    );
  }
}
