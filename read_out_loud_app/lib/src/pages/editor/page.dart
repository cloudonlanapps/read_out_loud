import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';

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
        return _EditorPage(
          filename: 'index.json',
          index: indexString == null ? null : int.parse(indexString),
          onClose: () {
            context.pop();
          },
        );
      };
}

class _EditorPage extends ConsumerWidget {
  final String filename;
  final int? index;
  final Function() onClose;
  const _EditorPage(
      {required this.filename, this.index, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(repositoryProvider(filename));

    return asyncValue.when(
        data: (Repository repository) => MainContent(
              repository: repository,
              onClose: onClose,
              index: index,
            ),
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator());
  }
}
