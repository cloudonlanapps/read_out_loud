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
    return Card(
      color: onTap == null ? Colors.grey : null,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8, top: 8),
      child: ListTile(
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
      ),
    );
  }
}
