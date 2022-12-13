import 'package:flutter/material.dart';

class Menu2 extends StatelessWidget {
  final double height;
  final List<Widget?> children;
  const Menu2({super.key, required this.height, required this.children});

  @override
  Widget build(BuildContext context) {
    if (children.length != 2) {
      throw Exception("Must have exactly 3 children");
    }
    List<Widget?> widgets = children;
    /* if (height < 75) {
      widgets = children
          .map((e) => FittedBox(fit: BoxFit.fitHeight, child: e))
          .toList();
    } else {
      widgets = children
          .map((e) => Padding(
              padding: EdgeInsets.symmetric(vertical: (height - 75) / 2),
              child: FittedBox(fit: BoxFit.fitHeight, child: e)))
          .toList();
    } */
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
              child: Align(
            //alignment: Alignment.centerLeft,
            child: widgets.first,
          )),
          Expanded(
              flex: 3,
              child: Align(
                //alignment: Alignment.center,
                child: widgets[1],
              )),
        ],
      ),
    );
  }
}
