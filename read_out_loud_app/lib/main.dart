import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:route_manager/route_manager.dart';

import 'src/constants.dart';
import 'src/pages/content_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  return runApp(
    DevicePreview(
      enabled: Platform.isMacOS ? !kReleaseMode : false,
      builder: (context) => ProviderScope(
          child: RouteManager(
        appName: Constants.appName,
        pageRoutes: [ContentListPage()],
      )),
    ),
  );
}
