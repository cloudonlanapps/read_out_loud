// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../page_builder/page_builder.dart';
import 'custom_widgets/menu_button.dart';
import 'page_main.dart';
import 'games/say_aloud.dart';

final gamePage = PageBuilder(
  name: 'game',
  mainAreaProminence: 0.9,
  builder: (BuildContext context, BoxConstraints constraints, WidgetRef ref) =>
      const DecoratedBox(
    decoration: BoxDecoration(
        //color: Colors.blue,
        //  border: Border.all(),
        ),
    child: SayAloud(),
  ),
  topNavMenuBuilder:
      (BuildContext context, BoxConstraints constraints, WidgetRef ref) =>
          DecoratedBox(
    decoration: const BoxDecoration(
        //color: Colors.red,
        //border: Border.all(),
        ),
    child: SizedBox(
      // height: constraints.maxHeight,
      // width: constraints.maxWidth,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: MenuButton(
                height: constraints.maxHeight,
                menuButtonItem: MenuButtonItem(
                    icon: Icons.home,
                    onTap: () {
                      context.goNamed(mainPage.name);
                    },
                    title: "Home"),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Flexible(
              child: MenuButton(
                height: constraints.maxHeight,
                menuButtonItem: MenuButtonItem(
                    icon: Icons.volume_off, onTap: () {}, title: "Mute"),
              ),
            )
          ],
        ),
      ),
    ),
  ),
);
