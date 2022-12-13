import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../custom_widgets/custom_menu.dart';

class TopMenu extends ConsumerWidget {
  final String filename;
  final Size size;
  final Function() onClose;
  final int? index;
  const TopMenu(
      {super.key,
      required this.filename,
      required this.onClose,
      required this.size,
      this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Repository> asyncValue = ref.watch(repositoryProvider(filename));
    String title = (index == null)
        ? "New Chapter"
        : asyncValue.whenOrNull(
                data: (Repository repository) =>
                    repository.chapters[index!].title) ??
            "";

    return Row(
      children: [
        CustomMenuButton(
          menuItem: CustomMenuItem(
            alignment: Alignment.centerRight,
            icon: Icons.arrow_back,
            onTap: onClose,
          ),
        ),
      ],
    );
  }
}

/***
 * 
 * 
 * 
 */