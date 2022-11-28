import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'page_builder.dart';

class PortraitScreen extends ConsumerWidget {
  const PortraitScreen({
    Key? key,
    required this.padding,
    required this.pageBuilder,
  }) : super(key: key);

  final EdgeInsets padding;
  final PageBuilder pageBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (pageBuilder.topNavMenuBuilder != null)
              Flexible(
                child: SafeArea(
                  bottom: false,
                  minimum: padding,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: LayoutBuilder(
                        builder: (context, constraints) => pageBuilder
                            .topNavMenuBuilder!(context, constraints, ref)),
                  ),
                ),
              ),
            SizedBox(
              height: constraints.maxHeight * pageBuilder.mainAreaProminence,
              //flex: (pageBuilder.mainAreaProminence * 100).round(),
              child: SafeArea(
                top: false,
                bottom: (pageBuilder.bottomNavMenuBuilder == null),
                minimum: padding,
                child: LayoutBuilder(
                    builder: (context, constraints) =>
                        pageBuilder.builder(context, constraints, ref)),
              ),
            ),
            if (pageBuilder.bottomNavMenuBuilder != null)
              Flexible(
                child: SafeArea(
                  top: false,
                  maintainBottomViewPadding: true,
                  minimum: padding,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: LayoutBuilder(
                        builder: (context, constraints) => pageBuilder
                            .bottomNavMenuBuilder!(context, constraints, ref)),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
