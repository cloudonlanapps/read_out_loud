import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';

import '../../../custom_widgets/custom_menu.dart';
import '../../editor/page.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final String filename;
  final Function() onClose;
  const TopMenu(
      {super.key,
      required this.onClose,
      required this.size,
      required this.filename});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Repository> asyncValue = ref.watch(repositoryProvider(filename));
    return Row(
      children: [
        CustomMenuButton(
          menuItem: CustomMenuItem(
            alignment: Alignment.centerRight,
            icon: Icons.arrow_back,
            onTap: onClose,
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Chapters",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: asyncValue.maybeWhen(
              data: (Repository repository) {
                return CustomMenuButton(
                  menuItem: CustomMenuItem(
                      alignment: Alignment.centerRight,
                      icon: Icons.add,
                      onTap: () => context.pushNamed(EditorPage().name),
                      title: "Add New"),
                );
              },
              orElse: () => CustomMenuButton(
                menuItem: CustomMenuItem(
                  alignment: Alignment.centerRight,
                  icon: Icons.warning_amber,
                ),
              ),
            )),
      ],
    );
  }
}
