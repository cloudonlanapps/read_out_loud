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
  String get name => 'chapter_list';

  @override
  String get path => '/$name';

  @override
  Widget Function(BuildContext context, GoRouterState state) get builder =>
      (context, state) {
        return PageView(
          filename: 'index.json',
          onClose: () {
            context.goNamed(MainPage().name);
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
      data: (repository) => LayoutBuilder(
        builder: (context, constraints) {
          final mainContentSize = Size(
            constraints.maxWidth,
            ResponsiveScreen.contentHeight(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              isBottom: true,
              isTop: true,
            ),
          );
          return ProviderScope(
            overrides: [
              contentPageProvider.overrideWith(
                (ref) => ContentPageNotifier(
                  ListPaginate<Chapter>(
                    width: mainContentSize.width,
                    height: mainContentSize.height,
                    items: repository.chapters,
                    minTileSize: 100,
                  ),
                ),
              )
            ],
            child: ResponsiveScreen(
              contentBuilder: (context, size) => const MainContent(),
              topMenuBuilder: (context, size) => TitleMenu(
                action: onClose,
                size: size,
                title: 'Select One',
              ),
              bottomMenubuilder: (context, size) => const BottomMenu(),
            ),
          );
        },
      ),
      error: (error, stackTrace) => Container(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
