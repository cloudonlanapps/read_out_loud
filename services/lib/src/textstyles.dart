import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle fullPageText(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge!;
  static TextStyle pageTitle(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium!;

  static TextStyle chapterTitle(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall!;

  static TextStyle chapterContent(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!;
  static TextStyle normal(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!;

  static TextStyle menuIcon(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall!;
}
