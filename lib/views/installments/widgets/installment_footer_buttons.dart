import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/containers/rounded_container.dart';
import '../../../utils/constants/sizes.dart';

class InstallmentFooterButtons extends StatelessWidget {
  const InstallmentFooterButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final InstallmentController installmentController = Get.find<InstallmentController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              flex: TDeviceUtils.isDesktopScreen(context) ? 6 : 0,
              child: const SizedBox()),

          //Buttons confirm print cancel
          Expanded(child: SizedBox(width: 150, child: OutlinedButton(onPressed: (){
            Get.back();
          }, child: const Text('Discard')),)),
          const SizedBox(width: TSizes.spaceBtwSections,),
          Expanded(child: SizedBox(width: 150, child: ElevatedButton(onPressed: (){}, child: const Text('Print only')),)),
          const SizedBox(width: TSizes.spaceBtwSections,),
          Expanded(child: SizedBox(width: 150, child: ElevatedButton(onPressed: (){
            installmentController.savePlan();

          }, child: const Text('Confirm&Print')),)),

        ],
      ),
    );
  }
}