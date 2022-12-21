import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'page_desc.dart';
import 'screen_background.dart';
import 'view_config.dart';

class RouteManager extends StatefulWidget {
  const RouteManager({
    required this.appName,
    required this.pageRoutes,
    this.defaultIndex = 0,
    this.locale,
    this.builder,
    this.viewConfig,
    super.key,
  });
  final String appName;
  final List<AppRoute> pageRoutes;
  final int defaultIndex;
  final Locale? locale;
  final Widget Function(BuildContext, Widget?)? builder;
  final ViewConfig? viewConfig;

  @override
  State<RouteManager> createState() => _RouteManagerState();
}

class _RouteManagerState extends State<RouteManager> {
  late ViewConfig viewConfig;
  @override
  void initState() {
    viewConfig = widget.viewConfig ?? ViewConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: <GoRoute>[
        ...widget.pageRoutes
            .map(
              (e) => GoRoute(
                path: e.path,
                name: e.name,
                pageBuilder: (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  transitionsBuilder: transitionBuilder,
                  child: ScreenBackground(
                    viewConfig: ViewConfig(),
                    builder: (context) => e.builder(context, state),
                  ),
                ),
              ),
            )
            .toList()
      ],
      redirect: (context, state) async => redirector(state),
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
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
          displayMedium: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
          displaySmall: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          bodyLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          bodyMedium: TextStyle(color: Colors.blueGrey, fontSize: 20),
          bodySmall: TextStyle(color: Colors.blueGrey, fontSize: 16),
          labelLarge: TextStyle(color: Colors.black, fontSize: 16),
          labelMedium: TextStyle(color: Colors.black, fontSize: 14),
          labelSmall: TextStyle(color: Colors.black, fontSize: 12),
        ),
      ),
    );
  }

  Future<String?> redirector(GoRouterState state) async {
    if (state.subloc == '/' || state.subloc == '') {
      return widget.pageRoutes[widget.defaultIndex].path;
    }
    return null;
  }

  Widget transitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (viewConfig.scheme) {
      case 'slide':
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(animation),
          child: child,
        );
      case 'scale':
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      case 'size':
        return Align(
          child: SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
        );
      case 'rotation':
        return RotationTransition(
          turns: animation,
          child: child,
        );
      case 'fade':
      default:
        return FadeTransition(opacity: animation, child: child);
    }
  }
}
