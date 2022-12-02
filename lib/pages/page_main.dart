// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../page_builder/page_builder.dart';
import '../providers/selected_list.dart';
import 'custom_widgets/custom_menu.dart';
import 'page_game.dart';
import 'page_settings.dart';

final mainPage = PageBuilder(
  name: 'main',
  builder: (BuildContext context, BoxConstraints constraints, WidgetRef ref) =>
      const DecoratedBox(
    decoration: BoxDecoration(
        //  color: Colors.blue,
        //  border: Border.all(),
        ),
    child: Center(
      child: Text(
        'Ready to Play?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 55,
          height: 1,
        ),
      ),
    ),
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
              child: CustomMenuButton(
                menuItem: CustomMenuItem(
                    icon: Icons.settings,
                    onTap: () {
                      context.goNamed(settingsPage.name);
                    },
                    title: "Settings"),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Flexible(
              child: CustomMenuButton(
                menuItem: CustomMenuItem(
                    icon: Icons.volume_off, onTap: () {}, title: "Mute"),
              ),
            )
          ],
        ),
      ),
    ),
  ),
  bottomNavMenuBuilder:
      (BuildContext context, BoxConstraints constraints, WidgetRef ref) =>
          Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomMenuButton(
          menuItem: CustomMenuItem(
              icon: Icons.play_circle_filled_outlined,
              onTap: () {
                ref
                    .read(selectedListProvider.notifier)
                    .newAsset('assets/wordlist1.json');
                //ref.read(speechRecogProvider.notifier).listen();
                context.goNamed(gamePage.name);
              },
              title: "Play"),
        ),
      ],
    ),
  ),
);
