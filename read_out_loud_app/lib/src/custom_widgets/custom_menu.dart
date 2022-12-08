import 'package:flutter/material.dart';

class CustomMenuItem {
  String? title;
  IconData? icon;
  final AlignmentGeometry alignment;
  void Function()? onTap;
  void Function()? onLongPress;
  double? scale;
  CustomMenuItem(
      {this.title,
      this.icon,
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
    return Transform.scale(
      scale: menuItem.scale ?? 1.0,
      child: InkWell(
        //splashColor: const Color.fromARGB(128, 255, 0, 0),
        onTap: menuItem.onTap,
        onLongPress: menuItem.onLongPress,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (menuItem.icon != null)
              Icon(
                menuItem.icon!,
                size: 40,
                color: menuItem.onTap == null ? Colors.grey : Colors.white,
              ),
            if (menuItem.title != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  menuItem.title!,
                  style: TextStyle(
                      color:
                          (menuItem.onTap == null) ? Colors.grey : Colors.white,
                      fontSize: 12),
                ),
              ),
          ],
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
