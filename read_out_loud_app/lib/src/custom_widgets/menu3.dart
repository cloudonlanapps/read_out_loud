import 'package:flutter/material.dart';

class Menu3 extends StatelessWidget {
  const Menu3({
    required this.height,
    required this.children,
    super.key,
  });
  final double height;
  final List<Widget?> children;

  @override
  Widget build(BuildContext context) {
    if (children.length != 3) {
      throw Exception('Must have exactly 3 children');
    }
    List<Widget> widgets;
    if (height < 75) {
      widgets = children
          .map((e) => FittedBox(fit: BoxFit.fitHeight, child: e))
          .toList();
    } else {
      widgets = children
          .map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: (height - 75) / 2),
              child: FittedBox(fit: BoxFit.fitHeight, child: e),
            ),
          )
          .toList();
    }
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Align(
              //alignment: Alignment.centerLeft,
              child: widgets.first,
            ),
          ),
          Expanded(
            child: Align(
              //alignment: Alignment.center,
              child: widgets[1],
            ),
          ),
          Expanded(
            child: Align(
              //alignment: Alignment.centerRight,
              child: widgets.last,
            ),
          ),
        ],
      ),
    );
  }
}
