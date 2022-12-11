import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import '../settings/page.dart';
import 'main.dart';
import 'top_menu.dart';

class AdvancedSettingsPage implements AppRoute {
  @override
  String get name => "advanced_settings";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (BuildContext context, GoRouterState state) {
        return PageView(
          filename: 'index.json',
          onClose: () {
            context.goNamed(SettingsPage().name);
          },
        );
      };
}

class PageView extends StatelessWidget {
  final String? filename;
  final Function() onClose;

  const PageView({
    super.key,
    required this.filename,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreen(
      contentBuilder: (context, size) =>
          MainContent(filename: filename, size: size),
      topMenuBuilder: (context, size) => TopMenu(onClose: onClose, size: size),
    );
  }
}
