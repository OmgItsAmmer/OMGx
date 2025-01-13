
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../common/widgets/loaders/animation_loader.dart';
import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    Get.dialog(
      PopScope(
        canPop: true,
        child: Container(
          color: THelperFunctions.isDarkMode(Get.context!)
              ? TColors.dark
              : TColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children:  [
              SizedBox(
                height: 250,
              ),
              TAnimationLoaderWidget(text: text, animation: animation,showAction: false),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }


  static stopLoading()
  {
    Navigator.of(Get.overlayContext!).pop();
  }
}
