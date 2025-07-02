import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/purchase_sales/purchase_sales_controller.dart';
import '../../../utils/validators/validation.dart';

class PurchaseSummary extends StatelessWidget {
  const PurchaseSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final PurchaseSalesController purchaseSalesController =
        Get.find<PurchaseSalesController>();

    // Check if the device is mobile
    final isMobile = TDeviceUtils.isMobileScreen(context);

    // For mobile use a column layout, for larger screens use row
    return isMobile
        ? _buildMobileLayout(context, purchaseSalesController)
        : _buildDesktopLayout(context, purchaseSalesController);
  }

  // Mobile-optimized vertical layout
  Widget _buildMobileLayout(
      BuildContext context, PurchaseSalesController purchaseSalesController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Discount controls
        Row(
          children: [
            // Discount field
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: purchaseSalesController.discountController,
                onChanged: (value) {
                  purchaseSalesController.applyDiscountInField(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  if (double.tryParse(value)! >
                      purchaseSalesController.netTotal.value) {
                    return 'Too high';
                  }
                  return null;
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Discount',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: TSizes.spaceBtwItems),

        // Net total display
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm, horizontal: TSizes.md),
          backgroundColor: TColors.primaryBackground.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'NET TOTAL',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: TSizes.xs),
              Obx(
                () => Text(
                  (purchaseSalesController.netTotal.value).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: TSizes.spaceBtwItems),

        // Payment tracking section
        _buildPaymentTracking(context, purchaseSalesController),
      ],
    );
  }

  // Desktop row-based layout
  Widget _buildDesktopLayout(
      BuildContext context, PurchaseSalesController purchaseSalesController) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 200,
              child: TextFormField(
                controller: purchaseSalesController.discountController,
                onChanged: (value) {
                  purchaseSalesController.applyDiscountInField(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Discount is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.tryParse(value)! >
                      purchaseSalesController.netTotal.value) {
                    return 'Discount cannot exceed the total amount';
                  }
                  return null;
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}'),
                  ),
                ],
                decoration: const InputDecoration(labelText: 'Discount'),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            TRoundedContainer(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'NET TOTAL',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Obx(
                    () => TRoundedContainer(
                      backgroundColor: TColors.primaryBackground,
                      width: 150,
                      height: 50,
                      child: Text(
                        (purchaseSalesController.netTotal.value)
                            .toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        // Payment tracking section
        _buildPaymentTracking(context, purchaseSalesController),
      ],
    );
  }

  // Payment tracking section for purchases
  Widget _buildPaymentTracking(
      BuildContext context, PurchaseSalesController purchaseSalesController) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: TColors.primaryBackground.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Tracking',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: purchaseSalesController.paidAmount,
                  onChanged: (value) {
                    try {
                      double paidAmount = double.tryParse(value) ?? 0.0;
                      double netTotal = purchaseSalesController.netTotal.value;

                      if (paidAmount > netTotal) {
                        purchaseSalesController.paidAmount.text = "0.0";
                        purchaseSalesController.remainingAmount.value.text =
                            netTotal.toStringAsFixed(2);
                      } else {
                        purchaseSalesController.remainingAmount.value.text =
                            (netTotal - paidAmount).toStringAsFixed(2);
                      }
                    } catch (e) {
                      purchaseSalesController.remainingAmount.value.text =
                          purchaseSalesController.netTotal.value
                              .toStringAsFixed(2);
                    }
                  },
                  validator: (value) =>
                      TValidator.validateEmptyText('Paid Amount', value),
                  decoration: const InputDecoration(
                    labelText: 'Amount Paid to Vendor',
                    hintText: '0.00',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Obx(() => TextFormField(
                      controller: purchaseSalesController.remainingAmount.value,
                      decoration: InputDecoration(
                        labelText: 'Remaining Amount Due',
                        hintText: '0.00',
                        suffixIcon: purchaseSalesController
                                    .remainingAmount.value.text.isNotEmpty &&
                                double.tryParse(purchaseSalesController
                                        .remainingAmount.value.text) !=
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
                      readOnly: true,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: purchaseSalesController.remainingAmount.value
                                        .text.isNotEmpty &&
                                    double.tryParse(purchaseSalesController
                                            .remainingAmount.value.text) !=
                                        null &&
                                    double.parse(purchaseSalesController
                                            .remainingAmount.value.text) >
                                        0
                                ? Colors.orange.shade700
                                : Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Text(
            'Track the amount paid to vendor and outstanding balance for this purchase.',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: TColors.grey,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}
