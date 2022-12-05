import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import 'bottom_menu.dart';
import 'main.dart';
import 'top_menu.dart';

class ContentListPage implements AppRoute {
  @override
  String get name => "content_list";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state, Size size)
      get builder => (BuildContext context, GoRouterState state, Size size) {
            return _ContentListPage(
              size: size,
              filename: state.queryParams['content list'] ?? 'index',
              onClose: () {},
            );
          };
}

class _ContentListPage extends StatelessWidget {
  final Size size;
  final String? filename;
  final Function() onClose;

  const _ContentListPage({
    required this.filename,
    required this.size,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreen(
      size: size,
      contentBuilder: (context, size) =>
          MainContent(filename: filename, size: size),
      topMenuBuilder: (context, size) => TopMenu(onClose: onClose, size: size),
      bottomMenubuilder: (context, size) =>
          BottomMenu(filename: filename, size: size),
    );
  }
}
