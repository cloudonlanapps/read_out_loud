import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle fullPageText(context) =>
      Theme.of(context).textTheme.displayLarge!;
  static TextStyle pageTitle(context) =>
      Theme.of(context).textTheme.displayMedium!;

  static TextStyle chapterTitle(context) =>
      Theme.of(context).textTheme.displaySmall!;

  static TextStyle chapterContent(context) =>
      Theme.of(context).textTheme.bodyLarge!;
  static TextStyle normal(context) => Theme.of(context).textTheme.bodySmall!;

  static TextStyle menuIcon(context) => Theme.of(context).textTheme.labelSmall!;
}
