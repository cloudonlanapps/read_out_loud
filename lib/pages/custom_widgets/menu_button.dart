import 'package:flutter/material.dart';

class MenuButtonItem {
  String? title;
  IconData icon;
  void Function()? onTap;
  MenuButtonItem({this.title, required this.icon, this.onTap});
}

class MenuButton extends StatelessWidget {
  final MenuButtonItem menuButtonItem;
  final double height;
  const MenuButton({
    super.key,
    required this.menuButtonItem,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color.fromARGB(128, 255, 0, 0),
      onTap: menuButtonItem.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            menuButtonItem.icon,
            size: 35,
            color: menuButtonItem.onTap == null
                ? Colors.grey.shade300
                : Colors.black,
          ),
          if (menuButtonItem.title != null)
            Container(
              margin: const EdgeInsets.only(top: 2),
              child: Text(
                menuButtonItem.title!,
                style: TextStyle(
                    color: menuButtonItem.onTap == null
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
