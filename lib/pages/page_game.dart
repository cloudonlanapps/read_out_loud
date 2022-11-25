// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../page_builder/page_builder.dart';

final gamePage = PageBuilder(
  name: 'game',
  builder: (BuildContext context, BoxConstraints constraints) => DecoratedBox(
    decoration: BoxDecoration(color: Colors.blue, border: Border.all()),
    child: const Center(
      child: Text(
        'Ready to Play?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 55,
          height: 1,
        ),
      ),
    ),
  ),
  topNavMenuBuilder: (BuildContext context, BoxConstraints constraints) =>
      DecoratedBox(
    decoration: BoxDecoration(color: Colors.red, border: Border.all()),
    child: const SizedBox(
      // height: constraints.maxHeight,
      // width: constraints.maxWidth,
      child: Center(child: Text("Top Menu")),
    ),
  ),
  bottomNavMenuBuilder: (BuildContext context, BoxConstraints constraints) =>
      DecoratedBox(
    decoration: BoxDecoration(color: Colors.yellow, border: Border.all()),
    child: const SizedBox(
      // height: constraints.maxHeight,
      // width: constraints.maxWidth,
      child: Center(child: Text("Bottom Menu")),
    ),
  ),
);
