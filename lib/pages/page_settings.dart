// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:read_out_loud/pages/page_main.dart';

import '../page_builder/page_builder.dart';
import 'custom_widgets/custom_menu.dart';

final settingsPage = PageBuilder(
  name: 'settings',
  mainAreaProminence: 0.9,
  builder: (BuildContext context, BoxConstraints constraints, WidgetRef ref) =>
      const Center(
    child: Text(
      'Settings',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 55,
        height: 1,
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
);
