// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'responsive_screen.dart';

class PageBuilder {
  static const double marginLeft = 2;
  static const double marginTop = 2;
  static const double marginRight = 2;
  static const double marginBottom = 2;

  static const double borderRadius = 15;
  final String name;

  final Widget Function(BuildContext context, BoxConstraints constraints)
      builder;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      topNavMenuBuilder;

  final Widget Function(BuildContext context, BoxConstraints constraints)?
      bottomNavMenuBuilder;

  final double mainAreaProminence;

  PageBuilder(
      {required this.name,
      required this.builder,
      this.mainAreaProminence = 0.8,
      this.topNavMenuBuilder,
      this.bottomNavMenuBuilder});

  String get path => "/$name";

  GoRoute get route {
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ClipRect(
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.only(
                    left: marginLeft,
                    right: marginRight,
                    top: marginTop,
                    bottom: marginBottom),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all()),
                child: ResponsiveScreen(pageBuilder: this),
              ),
            ),
          ),
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
