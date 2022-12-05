import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Size size;

  final double _progress;
  final double radius;
  final Color? _primaryColor;
  final Color? _secondaryColor;

  const ProgressBar(
      {super.key,
      required this.size,
      double progress = 0.0,
      this.radius = 50.0,
      Color? primaryColor,
      Color? secondaryColor})
      : _primaryColor = primaryColor,
        _secondaryColor = secondaryColor,
        _progress = progress;

  double get progress => _progress < 0
      ? 0
      : _progress > 1.0
          ? 1.0
          : _progress;
  Color get primaryColor => _primaryColor ?? Colors.green.shade300;
  Color get secondaryColor => _secondaryColor ?? Colors.white;
  Size get size1 => Size(size.width * progress, size.height);
  Size get size2 => Size(size.width * (1.0 - progress), size.height);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius), //Customize:
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(color: primaryColor), //Customize:
              child: SizedBox.fromSize(size: size1)),
          Container(
              decoration: BoxDecoration(color: secondaryColor),
              child: SizedBox.fromSize(size: size2)),
        ],
      ),
    );
  }
}
