import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';

import 'package:responsive_screen/responsive_screen.dart';

import 'package:route_manager/route_manager.dart';
import 'package:services/services.dart';

import '../../../custom_widgets/title_menu.dart';
import '../../main/page.dart';
import 'bottom_menu.dart';
import 'main.dart';
import 'providers/state_provider.dart';

class ContentListPage implements AppRoute {
  @override
  String get name => "chapter_list";

  @override
  String get path => "/$name";

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (BuildContext context, GoRouterState state) {
        return PageView(
          filename: 'index.json',
          onClose: () {
            context.goNamed(MainPage().name);
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
        data: (Repository repository) => LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  ProviderScope(
                overrides: [
                  contentPageProvider.overrideWith((ref) => ContentPageNotifier(
                      ListPaginate<Chapter>(
                          width: constraints.maxWidth,
                          height: ResponsiveScreen.contentHeight(
                              size: Size(
                                  constraints.maxWidth, constraints.maxHeight),
                              isBottom: true,
                              isTop: true),
                          items: repository.chapters)))
                ],
                child: ResponsiveScreen(
                  contentBuilder: (context, size) => const MainContent(),
                  topMenuBuilder: (context, size) => TitleMenu(
                    onClose: onClose,
                    size: size,
                    title: 'Select One',
                  ),
                  bottomMenubuilder: (context, size) => const BottomMenu(),
                ),
              ),
            ),
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator());
  }
}
