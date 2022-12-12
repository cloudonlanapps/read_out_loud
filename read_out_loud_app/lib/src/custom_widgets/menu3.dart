import 'package:flutter/material.dart';

class Menu3 extends StatelessWidget {
  final List<Widget?> children;
  const Menu3({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Align(
          alignment: Alignment.centerLeft,
          child: children.first,
        )),
        if (children.length == 3)
          Expanded(
              child: Align(
            alignment: Alignment.center,
            child: children[1],
          )),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: children.last,
        )),
      ],
    );
  }
}
