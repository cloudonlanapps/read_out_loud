import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoute {
  String get name;
  String get path;
  Widget Function(BuildContext context, GoRouterState state, Size size)
      get builder;
}
