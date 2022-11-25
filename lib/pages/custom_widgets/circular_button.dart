import 'package:flutter/material.dart';

class CircularButtonItem {
  String? title;
  IconData icon;
  void Function()? onTap;
  CircularButtonItem({this.title, required this.icon, this.onTap});
}

class CircularButton extends StatelessWidget {
  final CircularButtonItem menuButtonItem;
  final Color? backgroundColor;
  final double height;
  const CircularButton(
      {super.key,
      required this.menuButtonItem,
      required this.height,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FittedBox(
        fit: BoxFit.none,
        child: InkWell(
          splashColor: const Color.fromARGB(128, 255, 0, 0),
          onTap: menuButtonItem.onTap,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  menuButtonItem.icon,
                  size: 25,
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
          ),
        ),
      ),
    );
  }
}
