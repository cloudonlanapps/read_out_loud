import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import '../main/page.dart';
import 'main.dart';
import 'top_menu.dart';

class SettingsPage implements AppRoute {
  @override
  String get name => 'words';

  @override
  String get path => '/$name';

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (context, state) {
        return PageView(
          filename: 'index.json',
          onClose: () {
            context.goNamed(MainPage().name);
          },
        );
      };
}

class PageView extends StatelessWidget {
  const PageView({
    required this.filename,
    required this.onClose,
    super.key,
  });
  final String? filename;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreen(
      contentBuilder: (context, size) =>
          MainContent(filename: filename, size: size),
      topMenuBuilder: (context, size) =>
          TopMenu(onSettings: onClose, size: size),
    );
  }
}
