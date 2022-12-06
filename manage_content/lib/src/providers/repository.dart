import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../models/chapter.dart';
import '../models/repository.dart';

class RepositoryNotifier extends StateNotifier<AsyncValue<Repository>> {
  String fileName;
  RepositoryNotifier(this.fileName) : super(const AsyncValue.loading()) {
    load();
  }

  load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      String json = await loadString('$fileName.json');
      return Repository.fromJson(json);
    });
  }

  static Future<String> loadString(String filename) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File file = await install(
        assetFile: "assets/$filename", storageFile: "$path/$filename");
    return file.readAsString();
  }

  static Future<File> install(
      {required String assetFile, required String storageFile}) async {
    File? file = File(storageFile);
    if (!file.existsSync()) {
      ByteData byteData = await rootBundle.load(assetFile);

      File file = await File(storageFile).create(recursive: true);

      // copies data byte by byte
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file;
  }

  onClearProgress(Repository repository, Chapter chapter) {}
  onSelectItem(Repository repository, Chapter chapter) {}
}

final repositoryProvider = StateNotifierProvider.family<RepositoryNotifier,
    AsyncValue<Repository>, String>((ref, fileName) {
  return RepositoryNotifier(fileName);
});
