// fullscreen_ctroller.dart
import 'package:ecommerce_dashboard/platform/fullscreen_platform.dart';
import 'package:get/get.dart';

class FullscreenController extends GetxController {
  static FullscreenController get instance => Get.find<FullscreenController>();
  var isFullscreen = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getInitialState();
  }

  Future<void> _getInitialState() async {
    isFullscreen.value = await platformIsFullScreen();
  }

  Future<void> toggleFullscreen() async {
    final current = isFullscreen.value;
    await platformSetFullScreen(!current);
    isFullscreen.value = !current;
  }
}
