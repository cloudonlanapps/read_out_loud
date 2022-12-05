import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:read_out_loud_app/src/pages/settings/page.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import '../content_list/page.dart';
import 'bottom_menu.dart';
import 'main.dart';
import 'top_menu.dart';

class MainPage implements AppRoute {
  @override
  String get name => "main";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state, Size size)
      get builder => (BuildContext context, GoRouterState state, Size size) {
            return _ContentListPage(
              size: size,
              filename: state.queryParams['content list'] ?? 'index',
              onSettings: () {
                print("Opening ${SettingsPage().name}");
                context.goNamed(SettingsPage().name);
              },
              onPlay: () {
                print("Opening ${ContentListPage().name}");
                context.goNamed(ContentListPage().name);
              },
            );
          };
}

class _ContentListPage extends StatelessWidget {
  final Size size;
  final String? filename;
  final Function() onSettings;
  final Function() onPlay;

  const _ContentListPage(
      {required this.filename,
      required this.size,
      required this.onSettings,
      required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreen(
      size: size,
      contentBuilder: (context, size) =>
          MainContent(filename: filename, size: size),
      topMenuBuilder: (context, size) =>
          TopMenu(onSettings: onSettings, size: size),
      bottomMenubuilder: (context, size) =>
          BottomMenu(onPlay: onPlay, size: size),
    );
  }
}
