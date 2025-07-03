import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/vendor/vendor_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/unit_price_quantity.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/unit_total_price.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/purchase_sales/purchase_sales_controller.dart';
import '../../../views/sales/widgets/serial_variant_selector.dart';
import '../table/purchase_table.dart';
import '../widgets/purchase_unitPriceQuantity.dart';
import '../widgets/purchase_unit_total_price.dart';
import '../widgets/purchase_vendor_info.dart';
import '../widgets/purchase_product_bar.dart';
import '../widgets/purchase_summary.dart';
import '../widgets/purchase_action_buttons.dart';
import '../widgets/purchase_user_info.dart';
import '../widgets/purchase_variant_manager.dart';

class PurchaseSalesDesktop extends GetView<PurchaseSalesController> {
  const PurchaseSalesDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final vendorController = Get.find<VendorController>();
    // final addressController = Get.find<AddressController>();
    // final mediaController = Get.find<MediaController>();

    // Mark ready for GetX to manage reactive rebuilds
    final isContentReady = true.obs;

    return Obx(() => isContentReady.value
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  // Page title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Purchase Entry',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Vendor and User Info Section
                  Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: TRoundedContainer(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Info
                          const Expanded(flex: 1, child: PurchaseUserInfo()),
                          const SizedBox(width: TSizes.spaceBtwSections),

                          // Vendor Info
                          Expanded(
                              flex: 2,
                              child: PurchaseVendorInfo(
                                namesList: vendorController.allVendors
                                    .map((e) => e.fullName)
                                    .toList(),
                                hintText: 'Vendor Name',
                                userNameTextController:
                                    controller.vendorNameController,
                                onSelectedName: (val) async {
                                  await controller.handleVendorSelection(val);
                                },
                              )),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Product Entry Section
                  TRoundedContainer(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      children: [
                        // Toggle switch for merging products
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: TSizes.spaceBtwItems),
                          child: Row(
                            children: [
                              const Spacer(),
                              Tooltip(
                                message:
                                    'When ON: Add quantities to existing products with same ID and unit\nWhen OFF: Add as separate items even if same product exists',
                                textStyle: const TextStyle(
                                    color: TColors.white, fontSize: 12),
                                decoration: BoxDecoration(
                                  color: TColors.dark.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Merge identical items',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 8),
                                    Obx(() => Switch(
                                          value: controller
                                              .mergeIdenticalProducts.value,
                                          activeColor: TColors.primary,
                                          activeTrackColor: TColors.primary
                                              .withValues(alpha: 0.5),
                                          inactiveThumbColor: TColors.grey,
                                          inactiveTrackColor: TColors.grey
                                              .withValues(alpha: 0.5),
                                          onChanged: (value) {
                                            controller.mergeIdenticalProducts
                                                .value = value;
                                          },
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Product search and add bar
                        FocusTraversalGroup(
                          policy: OrderedTraversalPolicy(),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Product Bar
                              Expanded(
                                  child: FocusTraversalOrder(
                                order: const NumericFocusOrder(1.0),
                                child: PurchaseProductSearchBar(
                                    productNameFocus:
                                        controller.productNameFocus),
                              )),
                              const SizedBox(width: TSizes.spaceBtwItems),

                              // Unit Price Quantity
                              Expanded(
                                  child: FocusTraversalOrder(
                                order: const NumericFocusOrder(2.0),
                                child: PurchaseUnitPriceQuantity(
                                  unitPriceFocus: controller.unitPriceFocus,
                                  quantityFocus: controller.quantityFocus,
                                ),
                              )),
                              const SizedBox(width: TSizes.spaceBtwItems),

                              // Unit Total Price
                              Expanded(
                                  child: FocusTraversalOrder(
                                order: const NumericFocusOrder(4.0),
                                child: PurchaseUnitTotalPrice(
                                    totalPriceFocus:
                                        controller.totalPriceFocus),
                              )),
                              const SizedBox(width: TSizes.spaceBtwItems),

                              // Add Button
                              Expanded(
                                child: FocusTraversalOrder(
                                  order: const NumericFocusOrder(5.0),
                                  child: SizedBox(
                                    height: 58,
                                    width: double.infinity,
                                    child: Obx(() => ElevatedButton(
                                          focusNode: controller.addButtonFocus,
                                          onPressed: controller
                                                      .isLoading.value ||
                                                  controller
                                                      .isSerializedProduct.value
                                              ? null
                                              : () {
                                                  controller.addProduct();
                                                  // Request focus after adding
                                                  controller.productNameFocus
                                                      .requestFocus();
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: TColors.primary,
                                            foregroundColor: TColors.white,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: controller.isLoading.value
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: TColors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Text(
                                                  'Add',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              // Reset Button
                              TCircularIcon(
                                icon: Iconsax.refresh,
                                backgroundColor:
                                    TColors.primary.withValues(alpha: 0.1),
                                color: TColors.primary,
                                onPressed: () {
                                  // Reset product form fields
                                  controller.resetFields();
                                  // Request focus after resetting
                                  controller.productNameFocus.requestFocus();
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections / 2),

                  // Serialized Product Indicator (shows when a serialized product with variant is selected)
                  Obx(() => controller.isSerializedProduct.value &&
                          controller.selectedVariantId.value != -1
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: TSizes.spaceBtwItems),
                          child: TRoundedContainer(
                            backgroundColor:
                                TColors.primary.withValues(alpha: 0.1),
                            showBorder: true,
                            borderColor: TColors.primary.withValues(alpha: 0.3),
                            padding: const EdgeInsets.all(TSizes.md),
                            child: Row(
                              children: [
                                const Icon(
                                  Iconsax.tag,
                                  color: TColors.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: TSizes.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Serialized Product Selected',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: TColors.primary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Obx(() {
                                        final selectedVariant = controller
                                            .availableVariants
                                            .where((v) =>
                                                v.variantId ==
                                                controller
                                                    .selectedVariantId.value)
                                            .firstOrNull;
                                        return Text(
                                          selectedVariant != null
                                              ? 'Serial: ${selectedVariant.serialNumber} | Price: Rs ${selectedVariant.purchasePrice.toStringAsFixed(2)}'
                                              : 'Variant information loading...',
                                          style: const TextStyle(
                                            color: TColors.darkGrey,
                                            fontSize: 12,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.resetSerializedProductState();
                                    controller.dropdownController.clear();
                                    controller.selectedProductName.value = '';
                                    controller.selectedProductId.value = -1;
                                    controller.unitPrice.value.clear();
                                    controller.totalPrice.value.clear();
                                    controller.productNameFocus.requestFocus();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: TColors.primary,
                                    size: 20,
                                  ),
                                  tooltip: 'Clear selection',
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),

                  // Purchase Variant Manager (for serialized product management)
                  const PurchaseVariantManager(),

                  const SizedBox(height: TSizes.spaceBtwSections / 2),

                  // Purchase Table
                  const TRoundedContainer(height: 530, child: PurchaseTable()),
                  const SizedBox(height: TSizes.spaceBtwSections / 2),

                  // Action buttons and Summary
                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.defaultSpace / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: PurchaseActionButtons()),
                        Expanded(flex: 2, child: PurchaseSummary()),
                      ],  
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator()));
  }
}
