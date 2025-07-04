import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:get/get.dart';

class SideBarController extends GetxController {
  final activeItem = ' '.obs;
  final hoverItem = ''.obs;

  void changeActiveItem(String route) => activeItem.value = route;

  void changeHoverItem(String route) {
    if (!isActive(route)) {
      hoverItem.value = route;
    }
  }

  bool isActive(String route) => activeItem.value == route;
  bool isHovering(String route) => hoverItem.value == route;

  void menuOnTap(String route) {
    if (!isActive(route)) {
      changeActiveItem(route);
    }
    if (TDeviceUtils.isMobileScreen(Get.context!)) {
      Get.back();
    }

    Get.toNamed(route);

    //logout feature
  }
}
