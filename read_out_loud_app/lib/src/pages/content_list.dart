import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_manager/route_manager.dart';

class ContentListPage implements AppRoute {
  @override
  String get name => "main";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state, Size size)
      get builder => (BuildContext context, GoRouterState state, Size size) {
            return _ContentListPage(queryParams: state.queryParametersAll);
          };
}

class _ContentListPage extends StatelessWidget {
  final Map<String, List<String>>? queryParams;
  const _ContentListPage({this.queryParams});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Content List here"),
      ),
    );
  }
}
