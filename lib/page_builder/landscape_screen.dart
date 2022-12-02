import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud/page_builder/size_getter.dart';

import 'page_builder.dart';

class LandscapeScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: isLarge ? 10 : 10,
          child: SafeArea(
            right: false,
            maintainBottomViewPadding: true,
            minimum: padding,
            child: SizeGetter(builder: pageBuilder.builder),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              if (pageBuilder.topNavMenuBuilder != null)
                Expanded(
                  child: SafeArea(
                    bottom: pageBuilder.bottomNavMenuBuilder == null,
                    left: false,
                    minimum: padding,
                    maintainBottomViewPadding: true,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: LayoutBuilder(
                          builder: (context, constraints) => pageBuilder
                              .topNavMenuBuilder!(context, constraints, ref)),
                    ),
                  ),
                ),
              if (pageBuilder.bottomNavMenuBuilder != null)
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
                            builder: (context, constraints) =>
                                pageBuilder.bottomNavMenuBuilder!(
                                    context, constraints, ref)),
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
