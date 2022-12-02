// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'responsive_screen.dart';

class PageBuilder {
  static const double marginLeft = 2;
  static const double marginTop = 2;
  static const double marginRight = 2;
  static const double marginBottom = 2;

  static const double borderRadius = 15;
  final String name;

  final Widget Function(BuildContext context, BoxConstraints constraints,
      WidgetRef ref, Size size) builder;
  final Widget Function(
          BuildContext context, BoxConstraints constraints, WidgetRef ref)?
      topNavMenuBuilder;

  final Widget Function(
          BuildContext context, BoxConstraints constraints, WidgetRef ref)?
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ClipRect(
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              /*  margin: const EdgeInsets.only(
                  left: marginLeft,
                  right: marginRight,
                  top: marginTop,
                  bottom: marginBottom),
              padding: const EdgeInsets.all(4), */
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(),
                  gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromARGB(0xFF, 0x00, 0x8F, 0x8F),
                        Color.fromARGB(0xFF, 0x8F, 0x8F, 0x00),
                      ])),
              child: Stack(
                children: [
                  //const Rainbow(),
                  //const RainbowVertical(),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: Colors.grey.shade200.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  ResponsiveScreen(pageBuilder: this),
                ],
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

class ArcPainter extends CustomPainter {
  final double width;
  final double height;

  ArcPainter(this.width, this.height);
  @override
  void paint(Canvas canvas, Size size) {
    final size = min(width, height);
    // create a bounding square, based on the centre and radius of the arc
    Rect rect = Rect.fromPoints(const Offset(0, 0), Offset(size, size));

    // a fancy rainbow gradient
    Gradient gradient = LinearGradient(
      colors: const <Color>[
        Color.fromARGB(0x7F, 0xEE, 0x82, 0xEE), // Violet
        Color.fromARGB(0x7F, 0x4b, 0x00, 0x82), // Indigo
        Color.fromARGB(0x7F, 0x00, 0x00, 0xFF), // Blue
        Color.fromARGB(0x7F, 0x00, 0x80, 0x00), // Green
        Color.fromARGB(0x7F, 0xFf, 0xFF, 0x00), // Yellow
        Color.fromARGB(0x7F, 0xFF, 0xA5, 0x00), // Orange
        Color.fromARGB(0x7F, 0xFF, 0x00, 0x00), //Red
        //  Color.fromARGB(0x7F, 0xFF, 0x00, 0x00),
      ],
      stops: [0, 1, 2, 3, 4, 5, 6].map((e) => e / 6.0).toList(),
    );

    // create the Shader from the gradient and the bounding square
    final Paint paint = Paint()..shader = gradient.createShader(rect);

    // and draw an arc
    canvas.drawArc(rect, pi, pi, true, paint);

    canvas.drawArc(rect, 0, pi, true, paint);
  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) {
    return true;
  }
}
