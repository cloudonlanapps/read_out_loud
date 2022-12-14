library clipboard;

import 'package:flutter/services.dart';

class ClipboardManager {
  static Future<void> copy(String text) async {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      return;
    }
  }

  static Future<String> paste() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    return data?.text?.toString() ?? "";
  }
}
