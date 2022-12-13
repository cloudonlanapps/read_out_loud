import 'package:flutter/material.dart';

class CustomMenuItem {
  String? title;
  IconData? icon;
  final AlignmentGeometry alignment;
  void Function()? onTap;
  void Function()? onLongPress;
  double? scale;
  Color? color;
  CustomMenuItem(
      {this.title,
      this.icon,
      this.color,
      this.onTap,
      this.alignment = Alignment.center,
      this.onLongPress,
      this.scale});
}

class CustomMenuButton extends StatelessWidget {
  final CustomMenuItem menuItem;

  const CustomMenuButton({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    final color =
        menuItem.color ?? (menuItem.onTap == null ? Colors.grey : Colors.white);
    return Transform.scale(
      scale: menuItem.scale ?? 1.0,
      child: InkWell(
        //splashColor: const Color.fromARGB(128, 255, 0, 0),
        onTap: menuItem.onTap,
        onLongPress: menuItem.onLongPress,
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (menuItem.icon != null)
                Expanded(
                    child: FittedBox(
                        child: Icon(menuItem.icon!, size: 40, color: color))),
              if (menuItem.title != null)
                Expanded(
                  child: FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        menuItem.title!,
                        style: TextStyle(color: color, fontSize: 12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMenu extends StatelessWidget {
  final List<CustomMenuItem?> menuItems;

  const CustomMenu({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: menuItems
            .map((e) => Expanded(
                  child: Align(
                    alignment: (e == null) ? Alignment.center : e.alignment,
                    child: (e == null)
                        ? Container()
                        : CustomMenuButton(menuItem: e),
                  ),
                ))
            .toList());
  }
}
