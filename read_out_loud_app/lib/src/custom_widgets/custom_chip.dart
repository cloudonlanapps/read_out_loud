import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:services/services.dart';

class CustomChip extends StatelessWidget {
  final CustChipStyle chipStyle;
  final String label;
  final IconData? iconData;
  final Function()? onTap;

  const CustomChip(
      {super.key,
      required this.chipStyle,
      required this.label,
      this.iconData,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          chipTheme: AppChipTheme.of(context, chipStyles: chipStyle).data),
      child: Chip(
          label: Text(label),
          deleteIcon: Icon(iconData ?? Icons.close),
          onDeleted: onTap),
    );
  }
}
