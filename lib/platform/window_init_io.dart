import 'dart:io' show Platform;

import 'package:window_manager/window_manager.dart';

Future<void> initDesktopWindow() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
  }
}
