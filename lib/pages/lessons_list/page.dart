// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../page_builder/page_builder.dart';
import '../custom_widgets/custom_menu.dart';
import '../page_main.dart';

import '../../shared/providers/animating.dart';
import '../../shared/providers/size_provider.dart';

import 'model.dart';
import 'provider.dart';

part 'parts/view.dart';
part 'parts/list_items.dart';
part 'parts/bottom_menu.dart';
part 'parts/title.dart';

final lessonsListPage = PageBuilder(
    name: 'game',
    mainAreaProminence: 0.9,
    builder: (BuildContext context, BoxConstraints constraints, WidgetRef ref,
            Size size) =>
        DecoratedBox(
          decoration: const BoxDecoration(
              //color: Colors.blue,
              //  border: Border.all(),
              ),
          child: LessonListView(key: ValueKey(size.toString()), size: size),
        ),
    topNavMenuBuilder:
        (BuildContext context, BoxConstraints constraints, WidgetRef ref) =>
            SafeArea(
              top: false,
              child: CustomMenu(menuItems: [
                CustomMenuItem(
                  alignment: Alignment.centerLeft,
                  icon: Icons.arrow_back,
                  onTap: () async {
                    context.goNamed(mainPage.name);
                  },
                ),
                null,
                null
              ]),
            ),
    bottomNavMenuBuilder:
        (BuildContext context, BoxConstraints constraints, WidgetRef ref) {
      return const SafeArea(
        top: false,
        child: BottomMenu(),
      );
    });

 //