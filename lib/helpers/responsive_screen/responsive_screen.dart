import 'package:flutter/material.dart';

import '../../models/page_builder.dart';
import 'landscape_screen.dart';
import 'portrait_screen.dart';

class ResponsiveScreen extends StatelessWidget {
  final PageBuilder pageBuilder;

  const ResponsiveScreen({
    required this.pageBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // This widget wants to fill the whole screen.
        final size = constraints.biggest;
        const padding = EdgeInsets.zero; //.all(size.shortestSide / 30);

        if (size.height >= size.width) {
          return PortraitScreen(
            padding: padding,
            pageBuilder: pageBuilder,
          );
        } else {
          // "Landscape" / "tablet" mode.
          final isLarge = size.width > 900;

          return LandscapeScreen(
            padding: padding,
            pageBuilder: pageBuilder,
            isLarge: isLarge,
          );
        }
      },
    );
  }
}
