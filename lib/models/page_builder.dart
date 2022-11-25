// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../helpers/responsive_screen/responsive_screen.dart';

class PageBuilder {
  final String name;

  final Widget Function(BuildContext context, BoxConstraints constraints)
      builder;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      _topNavMenuBuilder;

  final Widget Function(BuildContext context, BoxConstraints constraints)?
      _bottomNavMenuBuilder;

  final double mainAreaProminence;

  PageBuilder(
      {required this.name,
      required this.builder,
      this.mainAreaProminence = 0.8,
      Widget Function(BuildContext context, BoxConstraints constraints)?
          topNavMenuBuilder,
      Widget Function(BuildContext context, BoxConstraints constraints)?
          bottomNavMenuBuilder})
      : _topNavMenuBuilder = topNavMenuBuilder,
        _bottomNavMenuBuilder = bottomNavMenuBuilder;

  String get path => "/$name";

  GoRoute get route {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: Scaffold(
          body: ResponsiveScreen(pageBuilder: this),
        ),
        transitionsBuilder: transitionBuilder,
      ),
    );
  }

  static Widget transitionBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    const String scheme = "scale";
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

  Widget Function(BuildContext context, BoxConstraints constraints)
      get topNavMenuBuilder =>
          _topNavMenuBuilder ?? (_, __) => const SizedBox.shrink();

  Widget Function(BuildContext context, BoxConstraints constraints)
      get bottomNavMenuBuilder =>
          _bottomNavMenuBuilder ?? (_, __) => const SizedBox.shrink();
}
