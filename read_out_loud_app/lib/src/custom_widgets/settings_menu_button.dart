import 'package:flutter/material.dart';

class SettingsMenuButton extends StatelessWidget {
  const SettingsMenuButton({
    required this.title,
    required this.onTap,
    super.key,
    this.subTitle,
    this.iconData = Icons.arrow_forward_ios,
  });
  final String title;
  final String? subTitle;
  final IconData? iconData;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: (subTitle == null)
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                subTitle!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
      contentPadding: EdgeInsets.zero,
      trailing: Icon(iconData),
    );
  }
}
