import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/guarantors/guarantor_controller.dart';
import 'package:admin_dashboard_v3/controllers/guarantors/guarantor_image_controller.dart';
import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstallmentFooterButtons extends StatelessWidget {
  const InstallmentFooterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final InstallmentController installmentController =
        Get.find<InstallmentController>();
    final GuarantorController guarantorController =
        Get.find<GuarantorController>();
    final GuarantorImageController guarantorImageController =
        Get.find<GuarantorImageController>();

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
          Expanded(
              child: SizedBox(
            width: 150,
            child: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Discard')),
          )),
          const SizedBox(
            width: TSizes.spaceBtwSections,
          ),
          Expanded(
              child: SizedBox(
            width: 150,
            child: ElevatedButton(
                onPressed: () {}, child: const Text('Print only')),
          )),
          const SizedBox(
            width: TSizes.spaceBtwSections,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                // Get the input values
                try {
                  // Save the installment plan and guarantor images
                  // (now correctly handled in savePlan method)
                  installmentController.savePlan();
                } catch (e) {
                  TLoader.errorSnackBar(title: 'Error', message: e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Create Installment Plan'),
            ),
          ),
          const SizedBox(
            width: TSizes.spaceBtwSections,
          ),
          Expanded(
              child: SizedBox(
            width: 150,
            child: TextButton(
                onPressed: () {
                  installmentController.clearAllFields();
                  guarantorImageController.clearGuarantorImages();
                  Get.back();
                },
                child: const Text('Cancel')),
          )),
        ],
      ),
    );
  }
}
