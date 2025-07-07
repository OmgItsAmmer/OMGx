import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/vendor/vendor_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/rendering.dart';

import '../../../controllers/purchase_sales/purchase_sales_controller.dart';
import '../table/purchase_table.dart';
import '../widgets/purchase_unitPriceQuantity.dart';
import '../widgets/purchase_unit_total_price.dart';
import '../widgets/purchase_vendor_info.dart';
import '../widgets/purchase_product_bar.dart';
import '../widgets/purchase_summary.dart';
import '../widgets/purchase_action_buttons.dart';
import '../widgets/purchase_user_info.dart';
import '../widgets/purchase_variant_manager.dart';

class PurchaseSalesMobile extends GetView<PurchaseSalesController> {
  const PurchaseSalesMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final vendorController = Get.find<VendorController>();

    // Mark ready for GetX to manage reactive rebuilds
    final isContentReady = true.obs;

    return Obx(() => isContentReady.value
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Column(
                children: [
                  // Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Purchase Entry',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Purchase Details section - collapsible
                  Obx(() => ExpansionTile(
                        childrenPadding: EdgeInsets.zero,
                        tilePadding:
                            const EdgeInsets.symmetric(horizontal: TSizes.sm),
                        title: Text(
                          "Purchase Details",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        initiallyExpanded: controller.isExpanded.value,
                        onExpansionChanged: (value) {
                          controller.toggleExpanded();
                        },
                        children: [
                          TRoundedContainer(
                            padding: const EdgeInsets.all(TSizes.sm),
                            margin: const EdgeInsets.symmetric(
                                horizontal: TSizes.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User Info
                                const PurchaseUserInfo(),
                                const SizedBox(height: TSizes.sm),

                                // Vendor Info
                                PurchaseVendorInfo(
                                  namesList: vendorController.allVendors
                                      .map((e) => e.fullName)
                                      .toList(),
                                  hintText: 'Vendor Name',
                                  userNameTextController:
                                      controller.vendorNameController,
                                  onSelectedName: (val) async {
                                    await controller.handleVendorSelection(val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Product Entry Section - collapsible
                  Obx(() => ExpansionTile(
                        childrenPadding: EdgeInsets.zero,
                        tilePadding:
                            const EdgeInsets.symmetric(horizontal: TSizes.sm),
                        title: Text(
                          "Add Products",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        initiallyExpanded:
                            controller.isProductEntryExpanded.value,
                        onExpansionChanged: (value) {
                          controller.isProductEntryExpanded.value = value;
                        },
                        children: [
                          TRoundedContainer(
                            padding: const EdgeInsets.all(TSizes.sm),
                            margin: const EdgeInsets.symmetric(
                                horizontal: TSizes.sm),
                            child: FocusTraversalGroup(
                              policy: OrderedTraversalPolicy(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              color: TColors.white,
                                              fontSize: 12),
                                          decoration: BoxDecoration(
                                            color: TColors.dark
                                                .withValues(alpha: 0.8),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Merge identical items',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(width: 8),
                                              Obx(() => Switch(
                                                    value: controller
                                                        .mergeIdenticalProducts
                                                        .value,
                                                    activeColor:
                                                        TColors.primary,
                                                    activeTrackColor: TColors
                                                        .primary
                                                        .withValues(alpha: 0.5),
                                                    inactiveThumbColor:
                                                        TColors.grey,
                                                    inactiveTrackColor: TColors
                                                        .grey
                                                        .withValues(alpha: 0.5),
                                                    onChanged: (value) {
                                                      controller
                                                          .mergeIdenticalProducts
                                                          .value = value;
                                                    },
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Product Bar
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(1.0),
                                    child: PurchaseProductSearchBar(
                                        productNameFocus:
                                            controller.productNameFocus),
                                  ),
                                  const SizedBox(height: TSizes.sm),

                                  // Unit Price Quantity
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(2.0),
                                    child: PurchaseUnitPriceQuantity(
                                      unitPriceFocus: controller.unitPriceFocus,
                                      quantityFocus: controller.quantityFocus,
                                    ),
                                  ),
                                  const SizedBox(height: TSizes.sm),

                                  // Unit(Kg/etc) Total Price
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(4.0),
                                    child: PurchaseUnitTotalPrice(
                                        totalPriceFocus:
                                            controller.totalPriceFocus),
                                  ),
                                  const SizedBox(height: TSizes.md),

                                  // Add Button - full width for mobile
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: FocusTraversalOrder(
                                            order: const NumericFocusOrder(5.0),
                                            child: Obx(() => ElevatedButton(
                                                  focusNode:
                                                      controller.addButtonFocus,
                                                  onPressed: controller
                                                              .isLoading
                                                              .value ||
                                                          controller
                                                              .isSerializedProduct
                                                              .value
                                                      ? null
                                                      : () {
                                                          controller
                                                              .addProduct();
                                                          controller
                                                              .productNameFocus
                                                              .requestFocus();
                                                        },
                                                  child:
                                                      controller.isLoading.value
                                                          ? const SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : const Text('Add'),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        TCircularIcon(
                                          icon: Iconsax.refresh,
                                          backgroundColor:
                                              TColors.primary.withOpacity(0.1),
                                          color: TColors.primary,
                                          onPressed: () {
                                            controller.resetFields();
                                            controller.productNameFocus
                                                .requestFocus();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Serialized Product Indicator (shows when a serialized product with variant is selected)
                  Obx(() => controller.isSerializedProduct.value &&
                          controller.selectedVariantId.value != -1
                      ? ExpansionTile(
                          childrenPadding: EdgeInsets.zero,
                          tilePadding:
                              const EdgeInsets.symmetric(horizontal: TSizes.sm),
                          title: Text(
                            "Serialized Product",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          initiallyExpanded: controller.isSerialExpanded.value,
                          onExpansionChanged: (value) {
                            controller.isSerialExpanded.value = value;
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: TSizes.sm),
                              child: TRoundedContainer(
                                backgroundColor:
                                    TColors.primary.withValues(alpha: 0.1),
                                showBorder: true,
                                borderColor:
                                    TColors.primary.withValues(alpha: 0.3),
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
                                                    controller.selectedVariantId
                                                        .value)
                                                .firstOrNull;
                                            return Text(
                                              selectedVariant != null
                                                  ? 'Variant: ${selectedVariant.variantName} | SKU: ${selectedVariant.sku ?? "N/A"}'
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
                                        controller
                                            .resetSerializedProductState();
                                        controller.dropdownController.clear();
                                        controller.selectedProductName.value =
                                            '';
                                        controller.selectedProductId.value = -1;
                                        controller.unitPrice.value.clear();
                                        controller.totalPrice.value.clear();
                                        controller.productNameFocus
                                            .requestFocus();
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
                            ),
                          ],
                        )
                      : const SizedBox.shrink()),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Purchase Variant Manager (for serialized product management)
                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.sm),
                    child: PurchaseVariantManager(),
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Current Cart Items
                  TRoundedContainer(
                    padding: const EdgeInsets.all(TSizes.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cart table header
                        Padding(
                          padding: const EdgeInsets.only(bottom: TSizes.sm),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Cart Items',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Obx(() => Text(
                                    '${controller.purchaseCartItem.length} item(s)',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )),
                            ],
                          ),
                        ),

                        // Responsive table with constrained height
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 300, // Maximum height
                            minHeight: 100, // Minimum height
                          ),
                          child: Obx(() => controller.purchaseCartItem.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(TSizes.lg),
                                    child: Text(
                                      'No items added yet',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.grey,
                                          ),
                                    ),
                                  ),
                                )
                              : const PurchaseTable()),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Purchase Summary - optimized for mobile
                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.sm),
                    child: PurchaseSummary(),
                  ),

                  const SizedBox(height: TSizes.md),

                  // Action buttons - full width for mobile
                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.sm),
                    child: PurchaseActionButtons(),
                  ),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator()));
  }
}
