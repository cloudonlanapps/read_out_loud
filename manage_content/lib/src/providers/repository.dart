import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/repository.dart';

class RepositoryNotifier extends StateNotifier<Repository> {
  RepositoryNotifier() : super(Repository(chapters: [])) {
    load();
  }

  load() async {
    String json = await loadString('index.json');
    state = Repository.fromJson(json);
  }

  static Future<String> loadString(String filename) async {
    String json;
    final path = await localDir;
    if (File("$path/$filename").existsSync()) {
      json = await File(filename).readAsString();
    } else {
      json = await rootBundle.loadString("assets/$filename");
    }
    return json;
  }

  static Future<String> get localDir async =>
      (await getApplicationDocumentsDirectory()).path;
}

final repositoryProvider =
    StateNotifierProvider<RepositoryNotifier, Repository>((ref) {
  return RepositoryNotifier();
});
