import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud_app/src/pages/words/page.dart';

import 'package:route_manager/route_manager.dart';

import 'src/pages/content_list/page.dart';
import 'src/pages/main/page.dart';
import 'src/pages/settings/page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
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
          WordsPage()
        ],
        defaultIndex: 0,
      )),
    ),
  );
}
