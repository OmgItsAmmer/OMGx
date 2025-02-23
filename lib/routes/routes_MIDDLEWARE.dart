import 'dart:io';

import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/views/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controllers/product/product_images_controller.dart';
import '../main.dart';

class   TRouteMiddleware extends GetMiddleware {

  @override
  RouteSettings? redirect(String? route) {
    final ProductImagesController productImagesController =
    Get.find<ProductImagesController>();
    productImagesController.selectedImage.value = null;
    const isAuthenticated = true;
    return isAuthenticated
        ? null
        : const RouteSettings(name: TRoutes.firstScreen);

  }
  }



  // bool isInternetAvailable() {
  //   try {
  //     final result = InternetAddress.lookup('example.com'); // Pinging Google
  //     return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  //   } catch (_) {
  //     return false;
  //   }
  // }


