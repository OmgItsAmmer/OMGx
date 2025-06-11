// fullscreen_ctroller.dart
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class FullscreenController extends GetxController {
  static FullscreenController get instance => Get.find<FullscreenController>();
  var isFullscreen = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getInitialState();
  }

  Future<void> _getInitialState() async {
    isFullscreen.value = await windowManager.isFullScreen();
  }

  Future<void> toggleFullscreen() async {
    bool current = isFullscreen.value;
    await windowManager.setFullScreen(!current);
    isFullscreen.value = !current;
  }
}
