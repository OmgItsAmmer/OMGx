import 'package:admin_dashboard_v3/common/widgets/loaders/loader_animation.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../common/widgets/loaders/animation_loader.dart';
import '../utils/constants/image_strings.dart';

class UnkownRoute extends StatelessWidget {
  const UnkownRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TAnimationLoaderWidget(
                text: 'Reality just glitched—try again!',
                animation: TImages.networkOut,
                showAction: false,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(TRoutes.login);
                  },
                  child: const Text("Take me Home!"))
            ],
          ),
        ),
      ),
    ));
  }
}
