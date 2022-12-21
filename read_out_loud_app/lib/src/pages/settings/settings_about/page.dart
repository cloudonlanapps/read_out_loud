import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import '../../../custom_widgets/title_menu.dart';
import '../../main/page.dart';
import 'main.dart';

class SettingsAboutPage implements AppRoute {
  @override
  String get name => 'settings-about';

  @override
  String get path => '/$name';

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (context, state) {
        return PageView(
          filename: 'index.json',
          onClose: () {
            try {
              context.pop();
            } on Exception {
              context.goNamed(MainPage().name);
            }
          },
        );
      };
}

class PageView extends ConsumerWidget {
  const PageView({
    required this.filename,
    required this.onClose,
    super.key,
  });
  final String filename;
  final Function() onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(repositoryProvider(filename));
    return asyncValue.when(
      data: (repository) => ResponsiveScreen(
        contentBuilder: (context, size) => MainContent(
          repository: repository,
          filename: filename,
        ),
        topMenuBuilder: (context, size) => TitleMenu(
          action: onClose,
          size: size,
          title: 'About',
        ),
      ),
      error: (error, stackTrace) => Container(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
