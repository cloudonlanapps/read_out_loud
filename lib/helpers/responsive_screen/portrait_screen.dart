import 'package:flutter/material.dart';

import '../../models/page_builder.dart';

class PortraitScreen extends StatelessWidget {
  const PortraitScreen({
    Key? key,
    required this.padding,
    required this.pageBuilder,
  }) : super(key: key);

  final EdgeInsets padding;
  final PageBuilder pageBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints.maxHeight);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: SafeArea(
                bottom: false,
                minimum: padding,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: LayoutBuilder(builder: pageBuilder.topNavMenuBuilder),
                ),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * pageBuilder.mainAreaProminence,
              //flex: (pageBuilder.mainAreaProminence * 100).round(),
              child: SafeArea(
                top: false,
                bottom: false,
                minimum: padding,
                child: LayoutBuilder(builder: pageBuilder.builder),
              ),
            ),
            Flexible(
              child: SafeArea(
                top: false,
                maintainBottomViewPadding: true,
                minimum: padding,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child:
                      LayoutBuilder(builder: pageBuilder.bottomNavMenuBuilder),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
