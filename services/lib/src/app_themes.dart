import 'package:flutter/material.dart';

enum CustChipStyle { normal, added, reported, deleted, succeeded }

class AppChipTheme {
  BuildContext context;
  CustChipStyle chipStyles;

  AppChipTheme._(this.context, this.chipStyles);

  factory AppChipTheme.of(BuildContext context,
      {required CustChipStyle chipStyles}) {
    return AppChipTheme._(context, chipStyles);
  }
  ChipThemeData get normal => ChipThemeData(
        labelStyle: textStyle,
        deleteIconColor: color,
      );
  ChipThemeData get data {
    switch (chipStyles) {
      case CustChipStyle.normal:
        return normal;

      case CustChipStyle.added:
        return normal.copyWith(backgroundColor: Colors.blueAccent);

      case CustChipStyle.reported:
        return normal.copyWith(backgroundColor: Colors.amberAccent);

      case CustChipStyle.deleted:
        return normal.copyWith(backgroundColor: Colors.redAccent);

      case CustChipStyle.succeeded:
        return normal.copyWith(backgroundColor: Colors.greenAccent);
    }
  }

  TextStyle get textStyle => Theme.of(context).textTheme.labelLarge!;
  Color get color => textStyle.color!;
}

class AppTextFieldTheme {
  static InputDecoration inputDecoration({required String label}) =>
      InputDecoration(
        label: Text(label),
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(width: 2, color: Colors.blueGrey), //<-- SEE HERE
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(width: 2, color: Colors.blueGrey), //<-- SEE HERE
          borderRadius: BorderRadius.circular(5.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(width: 2, color: Colors.red), //<-- SEE HERE
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(width: 2, color: Colors.red), //<-- SEE HERE
          borderRadius: BorderRadius.circular(5.0),
        ),
      );
}
