import 'package:ecommerce_dashboard/common/widgets/chips/rounded_choice_chips.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/controllers/shop/shop_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/sales/sales_controller.dart';
import '../../../utils/validators/validation.dart';

class SalesSummary extends StatelessWidget {
  const SalesSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.find<SalesController>();
    final shopController = Get.put(ShopController());
    shopController.fetchShop();

    // Check if the device is mobile
    final isMobile = TDeviceUtils.isMobileScreen(context);

    // For mobile use a column layout, for larger screens use row
    return isMobile
        ? _buildMobileLayout(context, salesController, shopController)
        : _buildDesktopLayout(context, salesController, shopController);
  }

  // Mobile-optimized vertical layout
  Widget _buildMobileLayout(BuildContext context,
      SalesController salesController, ShopController shopController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Discount controls
        Row(
          children: [
            // Profile button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showDiscountProfilesDialog(
                      context, salesController, shopController);
                },
                child: Text(
                  'Discount Profiles',
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: TColors.white,
                      ),
                ),
              ),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),

            // Discount field
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: salesController.discountController,
                onChanged: (value) {
                  salesController.applyDiscountInField(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  if (double.tryParse(value)! >
                      salesController.netTotal.value) {
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
                  (salesController.netTotal.value).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Desktop row-based layout
  Widget _buildDesktopLayout(BuildContext context,
      SalesController salesController, ShopController shopController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              _showDiscountProfilesDialog(
                  context, salesController, shopController);
            },
            child: Text(
              'Profile',
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: TColors.white,
                  ),
            ),
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: salesController.discountController,
            onChanged: (value) {
              salesController.applyDiscountInField(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Discount is required';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              if (double.tryParse(value)! > salesController.netTotal.value) {
                return 'Discount cannot exceed the total amount';
              }
              return null;
            },
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d{0,2}'),
              ),
            ],
            decoration: const InputDecoration(labelText: 'Discount'),
          ),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        TRoundedContainer(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'NET TOTAL',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                width: TSizes.spaceBtwItems,
              ),
              Obx(
                () => TRoundedContainer(
                  backgroundColor: TColors.primaryBackground,
                  width: 150,
                  height: 50,
                  child: Text(
                    (salesController.netTotal.value).toStringAsFixed(2),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Common dialog for both layouts
  void _showDiscountProfilesDialog(BuildContext context,
      SalesController salesController, ShopController shopController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Discounts(%)'),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile 1 Chip
              Expanded(
                child: SizedBox(
                  width: 150,
                  child: Obx(
                    () => TChoiceChip(
                      text: '${shopController.profile1.text}%',
                      selected: salesController.selectedChipIndex.value == 0,
                      onSelected: (val) {
                        salesController
                            .applyDiscountInChips(shopController.profile1.text);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),

              // Profile 2 Chip
              Expanded(
                child: Obx(
                  () => TChoiceChip(
                    text: '${shopController.profile2.text}%',
                    selected: salesController.selectedChipIndex.value == 1,
                    onSelected: (val) {
                      salesController
                          .applyDiscountInChips(shopController.profile2.text);
                    },
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),

              // Profile 3 Chip
              Expanded(
                child: Obx(
                  () => TChoiceChip(
                    text: '${shopController.profile3.text}%',
                    selected: salesController.selectedChipIndex.value == 2,
                    onSelected: (val) {
                      salesController
                          .applyDiscountInChips(shopController.profile3.text);
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
