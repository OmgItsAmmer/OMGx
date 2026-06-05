import 'package:window_manager/window_manager.dart';

Future<bool> platformIsFullScreen() => windowManager.isFullScreen();

Future<void> platformSetFullScreen(bool fullScreen) =>
    windowManager.setFullScreen(fullScreen);
