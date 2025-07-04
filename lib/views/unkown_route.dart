import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/network_manager.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/widgets/loaders/animation_loader.dart';
import '../utils/constants/image_strings.dart';

class UnkownRoute extends GetView<NetworkManager> {
  const UnkownRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final isPC = TDeviceUtils.isDesktopScreen(context);
    final isTablet = TDeviceUtils.isTabletScreen(context);
    final isMobile = TDeviceUtils.isMobileScreen(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            width: isMobile ? double.infinity : 500,
            //constraints: isPC ? const BoxConstraints(maxWidth: 600) : null,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TAnimationLoaderWidget(
                  text: 'Reality just glitched—try again!',
                  animation: TImages.networkOut,
                  showAction: false,
                  width: isMobile ? null : 500,
                  height: isMobile ? null : 500,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                      onPressed: () async {
                        final isConnected = await controller.isConnected();
                        if (isConnected) {
                          Get.offAllNamed(TRoutes.login);
                        } else {
                          TLoaders.warningSnackBar(
                              title: 'No Internet Connection!',
                              message:
                                  'Kindly check your internet connection if issue presist restart the app or internet');
                        }
                      },
                      child: const Text("Take me Home!")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
