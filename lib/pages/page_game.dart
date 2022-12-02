// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../page_builder/page_builder.dart';
import 'custom_widgets/custom_menu.dart';
import 'games/say_aloud.dart';
import 'page_main.dart';

final gamePage = PageBuilder(
    name: 'game',
    mainAreaProminence: 0.9,
    builder:
        (BuildContext context, BoxConstraints constraints, WidgetRef ref) =>
            const DecoratedBox(
              decoration: BoxDecoration(
                  //color: Colors.blue,
                  //  border: Border.all(),
                  ),
              child: SayAloud(),
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
        (BuildContext context, BoxConstraints constraints, WidgetRef ref) =>
            SafeArea(
              top: false,
              child: CustomMenu(menuItems: [
                CustomMenuItem(
                    icon: Icons.arrow_circle_left,
                    onTap: () async {
                      //await ref.read(wordsProvider.notifier).previous();
                    },
                    title: 'Prev'),
                null,
                CustomMenuItem(
                    icon: Icons.arrow_circle_right,
                    onTap: () async {
                      //await ref.read(wordsProvider.notifier).previous();
                    },
                    title: 'Next')
              ]),
            ));

 //