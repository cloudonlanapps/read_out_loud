import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import '../chapter_list/page.dart';
import 'bottom_menu.dart';
import 'main.dart';
import 'providers/state_provider.dart';
import 'top_menu.dart';

class ChapterPage implements AppRoute {
  @override
  String get name => 'chapter';

  @override
  String get path => '/$name';

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (context, state) {
        if (state.queryParams['filename'] == null) {
          throw Exception('WordsPage is invoked without providing a filename');
        }
        final contentListConfig =
            ContentListConfig(filename: state.queryParams['filename']!);
        return PageView(
          contentListConfig: contentListConfig,
          onClose: () {
            context.goNamed(ContentListPage().name);
          },
        );
      };
}

class PageView extends StatelessWidget {
  const PageView({
    required this.contentListConfig,
    required this.onClose,
    super.key,
  });
  final ContentListConfig contentListConfig;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreen(
      contentBuilder: (context, size) =>
          MainContent(contentListConfig: contentListConfig, size: size),
      topMenuBuilder: (context, size) => TopMenu(
        contentListConfig: contentListConfig,
        onClose: onClose,
        size: size,
      ),
      bottomMenubuilder: (context, size) =>
          BottomMenu(contentListConfig: contentListConfig, size: size),
    );
  }
}
