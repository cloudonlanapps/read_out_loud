import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'page_desc.dart';

class RouteManager extends StatefulWidget {
  final String appName;
  final List<AppRoute> pageRoutes;
  final int defaultIndex;
  final Locale? locale;
  final Widget Function(BuildContext, Widget?)? builder;
  const RouteManager(
      {super.key,
      required this.appName,
      required this.pageRoutes,
      this.defaultIndex = 0,
      this.locale,
      this.builder});

  @override
  State<RouteManager> createState() => _RouteManagerState();
}

class _RouteManagerState extends State<RouteManager> {
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: <GoRoute>[
        ...widget.pageRoutes
            .map((e) => GoRoute(
                path: e.path,
                name: e.name,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                    key: state.pageKey,
                    transitionsBuilder: transitionBuilder,
                    child: e.builder(context, state))))
            .toList()
      ],
      redirect: (context, state) async => await redirector(state),
    );
    return MaterialApp.router(
      useInheritedMediaQuery: true,
      locale: widget.locale, // DevicePreview.locale(context),
      builder: widget.builder, // DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      //routeInformationProvider: _router.routeInformationProvider,
      //routeInformationParser: _router.routeInformationParser,
      routerConfig: router,
      title: widget.appName,
    );
  }

  Future<String?> redirector(GoRouterState state) async {
    if (state.subloc == '/' || state.subloc == '') {
      return widget.pageRoutes[widget.defaultIndex].path;
    }
    return null;
  }

  static Widget transitionBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    const String scheme = "size";
    switch (scheme) {
      case "slide":
        return SlideTransition(
          position:
              Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                  .animate(animation),
          child: child,
        );
      case "scale":
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      case "size":
        return Align(
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0.0,
            child: child,
          ),
        );
      case "rotation":
        return RotationTransition(
          turns: animation,
          child: child,
        );
      case "fade":
      default:
        return FadeTransition(opacity: animation, child: child);
    }
  }
}
