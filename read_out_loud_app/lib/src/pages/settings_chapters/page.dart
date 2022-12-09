import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:read_out_loud_app/src/pages/settings/page.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import 'main.dart';
import 'top_menu.dart';

class SettingsChapterPage implements AppRoute {
  @override
  String get name => "settings-chapter";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state, Size size)
      get builder => (BuildContext context, GoRouterState state, Size size) {
            return PageView(
              size: size,
              filename: 'index',
              onClose: () {
                context.goNamed(SettingsPage().name);
              },
            );
          };
}

class PageView extends StatelessWidget {
  final Size size;
  final String filename;
  final Function() onClose;

  const PageView({
    super.key,
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
    );
  }
}
