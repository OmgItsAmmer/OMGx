
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../utils/constants/enums.dart';

class TRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // final ProductImagesController productImagesController =
    //   Get.find<ProductImagesController>();
    final MediaController mediaController = Get.find<MediaController>();

    mediaController.displayImage.value = null;
    for (var image in mediaController.allImages) {
      image.isSelected.value = false; // ✅ Reset checkbox state
    }
    mediaController.selectedImages.clear();
    mediaController.selectedPath.value = MediaCategory.folders;

    //
    // productImagesController.selectedImage.value = null;
    // const isAuthenticated = true;
    // return isAuthenticated
    //     ? null
    //     : const RouteSettings(name: TRoutes.firstScreen);

    // Run function when navigating to ProfileScreen
    if (route != null) {
      // Run function when navigating to ProfileScreen
      // if (route == TRoutes.profileScreen) {
      //   fetchProfileImage();
      // }
      // if (route == TRoutes.profileScreen) {
      //   fetchStoreImage();
      // }
    }

    return null;
  }

  // void fetchProfileImage()  async {
  //   try {
  //     //TLoader.successSnackBar(title: 'Pushed  by jynx');
  //     // final ProductImagesController productImagesController =
  //     // Get.find<ProductImagesController>();
  //     final MediaController mediaController =
  //     Get.find<MediaController>();
  //
  //     mediaController.selectedPath.value  = MediaCategory.users;
  //     // await  productImagesController.setDesiredImage(MediaCategory.users,
  //     //     UserController.instance.currentUser.value.userId);
  //
  //   }
  //   catch (e) {
  //     if (kDebugMode) {
  //       TLoader.errorSnackBar(title: 'Observer Profile', message: e.toString());
  //       print(e);
  //     }
  //   }
  // }
  //
  // void fetchStoreImage() {
  //   try {
  //
  //
  //     final MediaController mediaController =
  //     Get.find<MediaController>();
  //
  //     mediaController.selectedPath.value  = MediaCategory.shop;
  //     // ProductImagesController.instance.setDesiredImage(
  //     //     MediaCategory.shop, UserController.instance.currentUser.value.userId);
  //   }
  //   catch (e) {
  //     if (kDebugMode) {
  //       TLoader.errorSnackBar(title: 'Observer Profile', message: e.toString());
  //       print(e);
  //     }
  //   }
  // }

// bool isInternetAvailable() {
//   try {
//     final result = InternetAddress.lookup('example.com'); // Pinging Google
//     return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
//   } catch (_) {
//     return false;
//   }
// }
}
