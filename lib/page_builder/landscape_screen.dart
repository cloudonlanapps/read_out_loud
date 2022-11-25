import 'package:flutter/widgets.dart';

import 'page_builder.dart';

class LandscapeScreen extends StatelessWidget {
  const LandscapeScreen({
    Key? key,
    required this.padding,
    required this.pageBuilder,
    required this.isLarge,
  }) : super(key: key);

  final EdgeInsets padding;
  final PageBuilder pageBuilder;

  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: isLarge ? 7 : 5,
          child: SafeArea(
            right: false,
            maintainBottomViewPadding: true,
            minimum: padding,
            child: LayoutBuilder(builder: pageBuilder.builder),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  left: false,
                  minimum: padding,
                  maintainBottomViewPadding: true,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child:
                        LayoutBuilder(builder: pageBuilder.topNavMenuBuilder),
                  ),
                ),
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  left: false,
                  maintainBottomViewPadding: true,
                  minimum: padding,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: LayoutBuilder(
                          builder: pageBuilder.bottomNavMenuBuilder),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
