import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/installments/installments_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/widgets/loaders/tloaders.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/validators/validation.dart';

class SaleActionButtons extends StatelessWidget {
  const SaleActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();
    final InstallmentController installmentController =
        Get.find<InstallmentController>();

    return Row(
      children: [
        OutlinedButton(
            onPressed: () {
              salesController.resetFields();
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
                  if (salesController.allSales.isEmpty) {
                    TLoader.errorSnackBar(
                      title: 'Checkout Error',
                      message: 'No products added to checkout.',
                    );
                    return;
                  }

                  if (!salesController.salesmanFormKey.currentState!.validate() ||
                      !salesController.customerFormKey.currentState!
                          .validate() ||
                      !salesController.cashierFormKey.currentState!
                          .validate()) {
                    TLoader.errorSnackBar(
                      title: 'Form Validation Error',
                      message: 'Please fill all required fields correctly.',
                    );
                    return;
                  }

                  if (salesController.customerNameController.text.isEmpty) {
                    TLoader.errorSnackBar(
                      title: 'Customer Error',
                      message: 'Please enter customer name.',
                    );
                    return;
                  }

                  if (salesController.selectedDate.value == null) {
                    TLoader.errorSnackBar(
                      title: 'Date Error',
                      message: 'Please select a valid date.',
                    );
                    return;
                  }

                  if (salesController.salesmanNameController.text.isEmpty) {
                    TLoader.errorSnackBar(
                      title: 'Salesman Error',
                      message: 'Please enter salesman name.',
                    );
                    return;
                  }

                  if (salesController.selectedAddressId == -1) {
                    TLoader.errorSnackBar(
                      title: 'Address Error',
                      message: 'Please select a valid address.',
                    );
                    return;
                  }

                  if (salesController.selectedSaleType.value ==
                      SaleType.installment) {
                    // For installment sales, go directly to installment screen
                    installmentController.billAmount.value.text =
                        salesController.netTotal.value.toString();
                    installmentController.currentInstallmentPayments.clear();
                    Get.toNamed(TRoutes.installment);
                  } else {
                    // For cash sales, show checkout dialog
                    Get.defaultDialog(
                      title: "CheckOut Details",
                      content: TRoundedContainer(
                        width: 400,
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  'Total Amount: ${salesController.netTotal.value.toStringAsFixed(2)}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            TextFormField(
                              onChanged: (value) {
                                try {
                                  // Parse the entered value (paidAmount) safely
                                  double paidAmount =
                                      double.tryParse(value) ?? 0.0;
                                  double netTotal =
                                      salesController.netTotal.value;

                                  // Ensure paidAmount does not exceed netTotal
                                  if (paidAmount > netTotal) {
                                    // Reset paidAmount and remainingAmount to default
                                    salesController.paidAmount.text = "0.0";
                                    salesController.remainingAmount.value.text =
                                        netTotal.toStringAsFixed(2);

                                    // Show error message
                                    TLoader.errorSnackBar(
                                      title: "Invalid Payment",
                                      message:
                                          "Paid amount cannot exceed the total amount.",
                                    );
                                  } else {
                                    // Update remainingAmount with the valid paidAmount
                                    salesController.remainingAmount.value.text =
                                        (netTotal - paidAmount)
                                            .toStringAsFixed(2);
                                  }
                                } catch (e) {
                                  if (kDebugMode) {
                                    print("Error parsing double: $e");
                                  }
                                  // Reset remainingAmount to default value
                                  salesController.remainingAmount.value.text =
                                      salesController.netTotal.value
                                          .toStringAsFixed(2);
                                }
                              },
                              controller: salesController.paidAmount,
                              validator: (value) =>
                                  TValidator.validateEmptyText(
                                      'Paid Amount', value),
                              decoration: const InputDecoration(
                                  labelText: 'Paid Amount'),
                              style: Theme.of(context).textTheme.bodyMedium,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            Obx(() => TextFormField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*')),
                                  ],
                                  readOnly: true,
                                  controller:
                                      salesController.remainingAmount.value,
                                  validator: (value) =>
                                      TValidator.validateEmptyText(
                                          'Remaining Amount', value),
                                  decoration: const InputDecoration(
                                      labelText: 'Remaining Amount'),
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                                const SizedBox(
                                    width: TSizes.spaceBtwInputFields),
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          salesController.checkOut();
                                          Navigator.of(context).pop();
                                        },
                                        child: (salesController
                                                .isCheckingOut.value)
                                            ? const CircularProgressIndicator(
                                                color: TColors.white,
                                              )
                                            : Text(
                                                'Confirm',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .apply(
                                                        color: TColors.white),
                                              ))),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
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
