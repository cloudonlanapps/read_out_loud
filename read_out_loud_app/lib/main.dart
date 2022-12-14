import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:route_manager/route_manager.dart';

import 'src/pages/settings/settings_audio/page.dart';
import 'src/pages/player/chapter/page.dart';
import 'src/pages/player/chapter_list/page.dart';
import 'src/pages/editor/page.dart';
import 'src/pages/main/page.dart';
import 'src/pages/settings/settings_home/page.dart';
import 'src/pages/settings/settings_chapters/page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /* AdaptiveDialog.instance.updateConfiguration(
    macOS: AdaptiveDialogMacOSConfiguration(
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: TODO: _applicationIconImage,
      ),
    ),
  ); 
  final _applicationIconImage = Image.asset(
  'assets/images/love.png',
);
  */
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    //DeviceOrientation.landscapeLeft,
    //DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  return runApp(
    DevicePreview(
      enabled: Platform.isMacOS ? !kReleaseMode : false,
      builder: (context) => ProviderScope(
          child: RouteManager(
        appName: "Read Out Loud",
        pageRoutes: [
          MainPage(),
          ContentListPage(),
          SettingsPage(),
          ChapterPage(),
          SettingsChapterPage(),
          AdvancedSettingsPage(),
          EditorPage(),
        ],
        defaultIndex: 0,
      )),
    ),
  );
}
