import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:read_out_loud_app/src/pages/settings/settings_home/page.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import '../../custom_widgets/custom_menu.dart';
import '../../custom_widgets/menu3.dart';
import '../player/chapter_list/page.dart';
import 'main.dart';

class MainPage implements AppRoute {
  @override
  String get name => "main";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (BuildContext context, GoRouterState state) {
        return PageView(
          filename: 'index.json',
          onSettings: () {
            context.goNamed(SettingsPage().name);
          },
          onPlay: () {
            context.goNamed(ContentListPage().name);
          },
        );
      };
}

class PageView extends StatelessWidget {
  final String? filename;
  final Function() onSettings;
  final Function() onPlay;

  const PageView(
      {super.key,
      required this.filename,
      required this.onSettings,
      required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScreen(
        contentBuilder: (context, size) =>
            MainContent(filename: filename, onPlay: onPlay),
        topMenuBuilder: (context, size) =>
            Menu3(height: size.height, children: [
              null,
              null,
              Center(
                child: CustomMenuButton(
                    menuItem: CustomMenuItem(
                        icon: Icons.settings,
                        onTap: onSettings,
                        title: "Settings")),
              ),
            ]));
  }
}
