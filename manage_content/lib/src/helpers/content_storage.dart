import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

const assetPath = 'assets';

mixin ContentStorage {
  static Future<String> get path async =>
      (await getApplicationDocumentsDirectory()).path;
  static Future<bool> hasAsset(String filename) async =>
      await _loadAsset(filename) != null;

  static Future<bool> fileExists(String filename) async {
    final file = File('${await path}/$filename');

    return file.existsSync();
  }

  static Future<String> loadString(String filename) async {
    final file = await _readOpen(filename);
    if (file == null) {
      throw Exception('$filename not found');
    }

    return file.readAsString();
  }

  static Future<void> saveString(String filename, String string) async {
    final file = await _writeOpen(filename);
    if (file == null) {
      throw Exception("$filename can't create");
    }
    await file.writeAsString(string);
  }

  static Future<String?> _loadAsset(String filename) async {
    try {
      return await rootBundle.loadString('$assetPath/$filename');
    } on Exception {
      return null;
    }
  }

  static Future<File?> _writeOpen(filename) async {
    final file = '${await path}/$filename';

    return File(file).create(recursive: true);
  }

  static Future<File?> _readOpen(String filename) async {
    final file = File('${await path}/$filename');

    if (!file.existsSync()) {
      final asset = await _loadAsset(filename);
      if (asset == null) {
        return null;
      }

      await file.create(recursive: true);

      // copies data byte by byte
      await file.writeAsString(asset);
    }
    return file;
  }

  static Future<void> delete(String filename) async {
    final file = File('${await path}/$filename');
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}
