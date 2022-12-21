import 'package:flutter/material.dart';

class Menu2 extends StatelessWidget {
  const Menu2({
    required this.height,
    required this.children,
    super.key,
  });
  final double height;
  final List<Widget?> children;

  @override
  Widget build(BuildContext context) {
    if (children.length != 2) {
      throw Exception('Must have exactly 3 children');
    }
    final widgets = children;
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
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              //alignment: Alignment.center,
              child: widgets[1],
            ),
          ),
        ],
      ),
    );
  }
}
