import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/widgets/loaders/tloaders.dart';
import '../../../controllers/purchase_sales/purchase_sales_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/validators/validation.dart';

class PurchaseActionButtons extends StatelessWidget {
  const PurchaseActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseSalesController purchaseSalesController =
        Get.find<PurchaseSalesController>();

    return Row(
      children: [
        OutlinedButton(
            onPressed: () {
              // Show confirmation dialog before discarding changes
              Get.defaultDialog(
                title: "Confirm Discard",
                titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                content: const Text(
                  "Are you sure you want to discard all changes? This will clear all fields and reset the page.",
                  textAlign: TextAlign.center,
                ),
                confirm: ElevatedButton(
                  onPressed: () {
                    // Call the comprehensive reset method that clears everything
                    purchaseSalesController.clearPurchaseDetails();
                    Navigator.of(context).pop(); // Close the dialog

                    // Show success message
                    TLoaders.successSnackBar(
                      title: "Reset Complete",
                      message: "All fields have been cleared successfully.",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: TColors.white,
                  ),
                  child: const Text("Yes, Discard All"),
                ),
                cancel: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).pop(), // Close the dialog,
                  child: const Text("Cancel"),
                ),
              );
            },
            child: Text(
              'Discard',
              style: Theme.of(context).textTheme.bodyMedium,
            )),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        SizedBox(
            width: 100,
            child: ElevatedButton(
                onPressed: () {
                  // Validate all required fields before proceeding
                  if (purchaseSalesController.allPurchases.isEmpty) {
                    TLoaders.errorSnackBar(
                      title: 'Checkout Error',
                      message: 'No products added to checkout.',
                    );
                    return;
                  }

                  if (!purchaseSalesController.vendorFormKey.currentState!
                          .validate() ||
                      !purchaseSalesController.userFormKey.currentState!
                          .validate()) {
                    TLoaders.errorSnackBar(
                      title: 'Form Validation Error',
                      message: 'Please fill all required fields correctly.',
                    );
                    return;
                  }

                  if (purchaseSalesController
                      .vendorNameController.text.isEmpty) {
                    TLoaders.errorSnackBar(
                      title: 'Vendor Error',
                      message: 'Please enter vendor name.',
                    );
                    return;
                  }

                  if (purchaseSalesController.selectedDate.value == null) {
                    TLoaders.errorSnackBar(
                      title: 'Date Error',
                      message: 'Please select a valid date.',
                    );
                    return;
                  }

                  if (purchaseSalesController.selectedAddressId == -1) {
                    TLoaders.errorSnackBar(
                      title: 'Address Error',
                      message: 'Please select a valid address.',
                    );
                    return;
                  }

                  // Show checkout dialog for purchase confirmation
                  Get.defaultDialog(
                    title: "Purchase CheckOut Details",
                    content: TRoundedContainer(
                      width: 400,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() => Text(
                                'Total Amount: ${purchaseSalesController.netTotal.value.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleMedium,
                              )),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          Text(
                            'Amount Paid to Vendor',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems / 2),
                          TextFormField(
                            onChanged: (value) {
                              try {
                                // Parse the entered value (paidAmount) safely
                                double paidAmount =
                                    double.tryParse(value) ?? 0.0;
                                double netTotal =
                                    purchaseSalesController.netTotal.value;

                                // Allow paidAmount to be 0 or any amount up to netTotal
                                if (paidAmount > netTotal) {
                                  // Reset paidAmount and remainingAmount to default
                                  purchaseSalesController.paidAmount.text =
                                      "0.0";
                                  purchaseSalesController.remainingAmount.value
                                      .text = netTotal.toStringAsFixed(2);

                                  // Show error message
                                  TLoaders.errorSnackBar(
                                    title: "Invalid Payment",
                                    message:
                                        "Paid amount cannot exceed the total amount.",
                                  );
                                } else {
                                  // Update remainingAmount with the valid paidAmount
                                  purchaseSalesController
                                          .remainingAmount.value.text =
                                      (netTotal - paidAmount)
                                          .toStringAsFixed(2);
                                }
                              } catch (e) {
                                if (kDebugMode) {
                                  print("Error parsing double: $e");
                                }
                                // Reset remainingAmount to default value
                                purchaseSalesController
                                        .remainingAmount.value.text =
                                    purchaseSalesController.netTotal.value
                                        .toStringAsFixed(2);
                              }
                            },
                            controller: purchaseSalesController.paidAmount,
                            validator: (value) => TValidator.validateEmptyText(
                                'Paid Amount', value),
                            decoration: const InputDecoration(
                              labelText: 'Amount Paid Now',
                              hintText: '0.00 (Enter 0 for pay later)',
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          Text(
                            'Amount Remaining to Pay Later',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems / 2),
                          Obx(() => TextFormField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*')),
                                ],
                                readOnly: true,
                                controller: purchaseSalesController
                                    .remainingAmount.value,
                                validator: (value) =>
                                    TValidator.validateEmptyText(
                                        'Remaining Amount', value),
                                decoration: InputDecoration(
                                  labelText: 'Outstanding Balance',
                                  hintText: '0.00',
                                  suffixIcon: purchaseSalesController
                                              .remainingAmount
                                              .value
                                              .text
                                              .isNotEmpty &&
                                          double.tryParse(
                                                  purchaseSalesController
                                                      .remainingAmount
                                                      .value
                                                      .text) !=
                                              null &&
                                          double.parse(purchaseSalesController
                                                  .remainingAmount.value.text) >
                                              0
                                      ? Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.orange.shade600,
                                        )
                                      : Icon(
                                          Icons.check_circle,
                                          color: Colors.green.shade600,
                                        ),
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: purchaseSalesController
                                                  .remainingAmount
                                                  .value
                                                  .text
                                                  .isNotEmpty &&
                                              double.tryParse(
                                                      purchaseSalesController
                                                          .remainingAmount
                                                          .value
                                                          .text) !=
                                                  null &&
                                              double.parse(
                                                      purchaseSalesController
                                                          .remainingAmount
                                                          .value
                                                          .text) >
                                                  0
                                          ? Colors.orange.shade700
                                          : Colors.green.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                              )),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          Row(
                            children: [
                              Expanded(
                                  flex: TDeviceUtils.isDesktopScreen(context)
                                      ? 2
                                      : 0,
                                  child: const SizedBox()),
                              Expanded(
                                  child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ))),
                              const SizedBox(width: TSizes.spaceBtwInputFields),
                              Expanded(child: Obx(() {
                                final isCheckingOut =
                                    purchaseSalesController.isCheckingOut.value;
                                return ElevatedButton(
                                  onPressed: isCheckingOut
                                      ? null // Disable the button when checking out
                                      : () {
                                          purchaseSalesController.checkOut();
                                          Get.toNamed(TRoutes.purchaseSales);
                                        },
                                  child: isCheckingOut
                                      ? const CircularProgressIndicator(
                                          color: TColors.white,
                                        )
                                      : Container(
                                          width: TDeviceUtils.isMobileScreen(context) ? 120 : 160,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          child: Center(
                                            child: Text(
                                              'Confirm Purchase',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .apply(color: TColors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                );
                              })),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: Text(
                  'Checkout',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: TColors.white),
                ))),
      ],
    );
  }
}
