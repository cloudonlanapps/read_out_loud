import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'constants.dart';
import 'helpers/debug/template.dart' as template;

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: <GoRoute>[
        ...[template.pageBuilder].map((e) => e.route).toList()
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
      return template.pageBuilder.path;
    }
    return null;
  }
}
