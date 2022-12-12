import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

const assetPath = 'assets';

mixin ContentStorage {
  static Future<String> get path async =>
      (await getApplicationDocumentsDirectory()).path;
  static Future<bool> hasAsset(String filename) async =>
      await _loadAsset(filename) == null ? false : true;

  static Future<bool> fileExists(String filename) async {
    File file = File("${await path}/$filename");

    return file.existsSync();
  }

  static Future<String> loadString(String filename) async {
    File? file = await _readOpen(filename);
    if (file == null) {
      throw Exception("$filename not found");
    }

    return file.readAsString();
  }

  static Future<void> saveString(String filename, String string) async {
    File? file = await _writeOpen(filename);
    if (file == null) {
      throw Exception("$filename can't create");
    }
    file.writeAsString(string);
  }

  static Future<String?> _loadAsset(String filename) async {
    try {
      return await rootBundle.loadString("$assetPath/$filename");
    } catch (e) {
      return null;
    }
  }

  static Future<File?> _writeOpen(filename) async {
    String file = "${await path}/$filename";

    return await File(file).create(recursive: true);
  }

  static Future<File?> _readOpen(filename) async {
    File file = File("${await path}/$filename");

    if (!file.existsSync()) {
      String? asset = await _loadAsset(filename);
      if (asset == null) {
        return null;
      }

      await file.create(recursive: true);

      // copies data byte by byte
      await file.writeAsString(asset);
    }
    return file;
  }

  static delete(String filename) async {
    File file = File("${await path}/$filename");
    file.deleteSync();
  }
}
