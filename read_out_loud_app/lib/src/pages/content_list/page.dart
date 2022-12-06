import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import '../main/page.dart';
import 'bottom_menu.dart';
import 'list_items.dart';
import 'main.dart';
import 'state_provider.dart';
import 'top_menu.dart';

class ContentListPage implements AppRoute {
  @override
  String get name => "content_list";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state, Size size)
      get builder => (BuildContext context, GoRouterState state, Size size) {
            double hContent = ResponsiveScreen.contentHeight(
                size: size, isBottom: true, isTop: true);
            ContentListConfig contentListConfig = ContentListConfig(
                repoPath: state.queryParams['content list'] ?? 'index',
                itemsPerPage: itemsPerPage(hContent));
            return PageView(
              size: size,
              contentListConfig: contentListConfig,
              onClose: () {
                context.goNamed(MainPage().name);
              },
            );
          };

  static int itemsPerPage(double totalHeight) =>
      (totalHeight - 75.0) ~/ ListItems.tileHeight;
}

class PageView extends StatelessWidget {
  final Size size;
  final ContentListConfig contentListConfig;
  final Function() onClose;

  const PageView({
    super.key,
    required this.contentListConfig,
    required this.size,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreen(
      size: size,
      contentBuilder: (context, size) =>
          MainContent(contentListConfig: contentListConfig, size: size),
      topMenuBuilder: (context, size) => TopMenu(onClose: onClose, size: size),
      bottomMenubuilder: (context, size) =>
          BottomMenu(contentListConfig: contentListConfig, size: size),
    );
  }
}
