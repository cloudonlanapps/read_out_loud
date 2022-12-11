import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import '../main/page.dart';
import 'bottom_menu.dart';
import 'widgets/chapter_list_view.dart';
import 'main.dart';
import 'providers/state_provider.dart';
import 'top_menu.dart';

class ContentListPage implements AppRoute {
  @override
  String get name => "chapter_list";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (BuildContext context, GoRouterState state) {
        ContentListConfig contentListConfig = ContentListConfig(
            repoPath: 'index.json', itemsPerPage: 10); //TODO Avoid this
        return PageView(
          contentListConfig: contentListConfig,
          onClose: () {
            context.goNamed(MainPage().name);
          },
        );
      };

  static int itemsPerPage(double totalHeight) =>
      (totalHeight - 75.0) ~/ ChapterListView.tileHeight;
}

class PageView extends StatelessWidget {
  final ContentListConfig contentListConfig;
  final Function() onClose;

  const PageView({
    super.key,
    required this.contentListConfig,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreen(
      contentBuilder: (context, size) =>
          MainContent(contentListConfig: contentListConfig, size: size),
      topMenuBuilder: (context, size) => TopMenu(onClose: onClose, size: size),
      bottomMenubuilder: (context, size) =>
          BottomMenu(contentListConfig: contentListConfig, size: size),
    );
  }
}
