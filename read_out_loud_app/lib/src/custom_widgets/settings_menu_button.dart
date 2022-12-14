import 'package:flutter/material.dart';

class SettingsMenuButton extends StatelessWidget {
  final String title;
  final String? subTitle;
  final IconData? iconData;
  final Function()? onTap;
  const SettingsMenuButton({
    super.key,
    required this.title,
    this.subTitle,
    this.iconData = Icons.arrow_forward_ios,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: (subTitle == null)
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                subTitle!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
      contentPadding: const EdgeInsets.all(8),
      trailing: Icon(iconData),
    );
  }
}
