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

    // Function to show confirmation dialog
    void showDiscardConfirmation() {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Confirm Discard'),
            content: const Text(
                'Are you sure you want to discard the installment plan? All data will be lost.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Discard'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Close the dialog
                  installmentController.clearAllFields();
                  guarantorImageController.clearGuarantorImages();
                  Navigator.of(context).pop(); // Go back to previous screen
                },
              ),
            ],
          );
        },
      );
    }

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Empty space on the left side
          Expanded(
            flex: TDeviceUtils.isDesktopScreen(context) ? 6 : 0,
            child: const SizedBox(),
          ),

          // Discard button
          Expanded(
            child: SizedBox(
              width: 150,
              child: OutlinedButton(
                onPressed: showDiscardConfirmation,
                child: const Text('Discard'),
              ),
            ),
          ),

          const SizedBox(width: TSizes.spaceBtwSections),

          // Print only button
          Expanded(
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the report page without saving the plan
                  installmentController.navigateToReportWithoutSaving();
                },
                child: const Text('Print only'),
              ),
            ),
          ),

          const SizedBox(width: TSizes.spaceBtwSections),

          // Create Installment Plan button
          Expanded(
            flex: 2,
            child: SizedBox(
              width: 200,
              child: Obx(() {
                final isSaving = installmentController.isSavingPlan.value;
                return ElevatedButton(
                  onPressed: isSaving
                      ? null // Disable the button when saving
                      : () async {
                          try {
                            // Save the installment plan and guarantor images
                            await installmentController.savePlan();
                          } catch (e) {
                            TLoader.errorSnackBar(
                                title: 'Error', message: e.toString());
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSaving
                        ? Colors.grey // Grey out the button when saving
                        : TColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: isSaving
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Create Plan'),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
