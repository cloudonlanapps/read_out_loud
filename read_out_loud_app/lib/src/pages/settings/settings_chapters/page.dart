import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';

import 'package:responsive_screen/responsive_screen.dart';
import 'package:route_manager/route_manager.dart';

import '../../../custom_widgets/custom_menu.dart';
import '../../../custom_widgets/title_menu.dart';
import '../../editor/page.dart';
import '../../main/page.dart';
import 'main.dart';

class SettingsChapterPage implements AppRoute {
  @override
  String get name => "settings-chapter";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (BuildContext context, GoRouterState state) {
        return PageView(
          filename: 'index.json',
          onClose: () {
            try {
              context.pop();
            } catch (e) {
              context.goNamed(MainPage().name);
            }
          },
        );
      };
}

class PageView extends ConsumerWidget {
  final String filename;
  final Function() onClose;

  const PageView({
    super.key,
    required this.filename,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Repository> asyncValue = ref.watch(repositoryProvider(filename));
    return asyncValue.when(
        data: (Repository repository) => ResponsiveScreen(
              contentBuilder: (context, size) =>
                  MainContent(repository: repository),
              topMenuBuilder: (context, size) => TitleMenu(
                title: "Chapters",
                action: onClose,
                size: size,
                rightWidget: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CustomMenuButton(
                    menuItem: CustomMenuItem(
                        alignment: Alignment.centerRight,
                        icon: Icons.add,
                        onTap: () => context.pushNamed(EditorPage().name),
                        title: "New"),
                  ),
                ),
              ),
            ),
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator());
  }
}
