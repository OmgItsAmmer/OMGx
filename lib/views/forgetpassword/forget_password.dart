import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:admin_dashboard_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/forget_password/forget_password.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/validators/validation.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          width: TDeviceUtils.isMobileScreen(context) ? double.infinity : 400,
          height: TDeviceUtils.isMobileScreen(context) ? double.infinity : 400,
          child: Obx(() {
            if (!controller.isAvaliable.value) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'This feature is not available in the free plan.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: TSizes.buttonWidth,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Optionally, you can add navigation or other actions here
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Iconsax.tick_circle,
                        color: TColors.white,
                      ),
                      label: const Text('Got It!'),
                    ),
                  ),
                ],
              );
            } else {
              return Form(
                key: controller.forgetPasswordFormKey,
                child: Column(
                  children: [
                    //Headings
                    Text(
                      TTexts.forgetPasswordTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),
                    Text(
                      TTexts.forgetPasswordSubTitle,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwSections * 2,
                    ),

                    //TextFields
                    TextFormField(
                      controller: controller.email,
                      validator: TValidator.validateEmail,
                      decoration: const InputDecoration(
                          labelText: TTexts.email,
                          prefixIcon: Icon(Iconsax.direct_right)),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwSections,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () =>
                                controller.sendPasswordResetEmail(),
                            child: const Text(TTexts.submit))),

                    //Submit Butoon
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
