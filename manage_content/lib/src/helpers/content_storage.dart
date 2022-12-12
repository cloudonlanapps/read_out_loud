import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

const assetPath = 'assets';

mixin ContentStorage {
  static Future<bool> hasAsset(String filename) async =>
      await _loadAsset(filename) == null ? false : true;

  static Future<String> loadString(String filename) async {
    File? file = await _readOpen(filename);
    if (file == null) {
      throw Exception("$filename not found");
    }
    print("$filename reading file now");
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
      print("asset not found!!! $assetPath/$filename");
      return null;
    }
  }

  static Future<File?> _writeOpen(filename) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    return await File("$path/$filename").create(recursive: true);
  }

  static Future<File?> _readOpen(filename) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File file = File("$path/$filename");
    print("$filename :$file");
    if (!file.existsSync()) {
      print("$filename :file not exists");
      String? asset = await _loadAsset(filename);
      if (asset == null) {
        print("$filename :asset not present");
        return null;
      }
      print("$filename :copying asset content");
      await file.create(recursive: true);

      // copies data byte by byte
      await file.writeAsString(asset);
    }
    return file;
  }
}
