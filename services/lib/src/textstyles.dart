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

  static TextStyle chipContentNormal(
    context,
  ) =>
      Theme.of(context).textTheme.labelLarge!;

  static TextStyle chipContentError(
    context,
  ) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(
            decoration: TextDecoration.lineThrough,
            decorationThickness: 3,
            decorationColor: Colors.redAccent,
          );
  static TextStyle chipContentNew(
    context,
  ) =>
      Theme.of(context).textTheme.labelLarge!;
  static TextStyle chipContentDeleted(
    context,
  ) =>
      Theme.of(context).textTheme.labelLarge!;
}
