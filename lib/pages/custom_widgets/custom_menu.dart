import 'package:flutter/material.dart';

class CustomMenuItem {
  String? title;
  IconData icon;
  final AlignmentGeometry alignment;
  void Function()? onTap;
  CustomMenuItem(
      {this.title,
      required this.icon,
      this.onTap,
      this.alignment = Alignment.center});
}

class CustomMenuButton extends StatelessWidget {
  final CustomMenuItem menuItem;

  const CustomMenuButton({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //splashColor: const Color.fromARGB(128, 255, 0, 0),
      onTap: menuItem.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            menuItem.icon,
            size: 40,
            color: menuItem.onTap == null ? Colors.grey.shade300 : Colors.black,
          ),
          if (menuItem.title != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                menuItem.title!,
                style: TextStyle(
                    color: menuItem.onTap == null
                        ? Colors.grey.shade300
                        : Colors.black,
                    fontSize: 12),
              ),
            ),
        ],
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
