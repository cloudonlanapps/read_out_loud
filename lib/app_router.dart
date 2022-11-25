import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:read_out_loud/pages/page_game.dart';

import 'constants.dart';
import 'page_builder/example_page_builder.dart';
import 'pages/page_main.dart';
import 'pages/page_settings.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: <GoRoute>[
        ...[examplePageBuilder, mainPage, settingsPage, gamePage]
            .map((e) => e.route)
            .toList()
      ],
      redirect: (context, state) async => await redirector(state),
    );
    return MaterialApp.router(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      //routeInformationProvider: _router.routeInformationProvider,
      //routeInformationParser: _router.routeInformationParser,
      routerConfig: router,
      title: Constants.appName,
    );
  }

  Future<String?> redirector(GoRouterState state) async {
    if (state.subloc == '/' || state.subloc == '') {
      return mainPage.path;
    }
    return null;
  }
}
