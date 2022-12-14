import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:route_manager/route_manager.dart';

import 'main.dart';

class EditorPage implements AppRoute {
  @override
  String get name => "editor";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (BuildContext context, GoRouterState state) {
        final String? indexString = state.queryParams['index'];
        return MainContent(
          filename: 'index.json',
          index: indexString == null ? null : int.parse(indexString),
          onClose: () {
            context.pop();
          },
        );
      };
}
