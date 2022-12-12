import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import 'main.dart';
import 'top_menu.dart';

class EditorPage implements AppRoute {
  @override
  String get name => "editor";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (BuildContext context, GoRouterState state) {
        final String? indexString = state.queryParams['index'];
        return PageView(
          filename: 'index.json',
          index: indexString == null ? null : int.parse(indexString),
          onClose: () {
            context.pop();
          },
        );
      };
}

class PageView extends StatelessWidget {
  final String filename;
  final Function() onClose;
  final int? index;

  const PageView({
    super.key,
    required this.filename,
    required this.index,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreen(
      contentBuilder: (context, size) =>
          MainContent(filename: filename, index: index, size: size),
      topMenuBuilder: (context, size) => TopMenu(onClose: onClose, size: size),
    );
  }
}
