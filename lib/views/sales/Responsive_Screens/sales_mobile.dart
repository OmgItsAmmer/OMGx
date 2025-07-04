import 'package:ecommerce_dashboard/Models/address/address_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/address/address_controller.dart';
import 'package:ecommerce_dashboard/controllers/customer/customer_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/sales/widgets/sale_action_buttons.dart';
import 'package:ecommerce_dashboard/views/sales/widgets/serial_variant_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/rendering.dart';

import '../../../Models/customer/customer_model.dart';
import '../../../controllers/media/media_controller.dart';
import '../../../controllers/sales/sales_controller.dart';
import '../table/sale_table.dart';
import '../widgets/cashier_info.dart';
import '../widgets/sale_customer_info.dart';
import '../widgets/sale_product_bar.dart';
import '../widgets/sales_saleman_info.dart';
import '../widgets/sales_summary.dart';
import '../widgets/unit_price_quantity.dart';
import '../widgets/unit_total_price.dart';

class SalesMobile extends GetView<SalesController> {
  const SalesMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final customerController = Get.find<CustomerController>();
    final addressController = Get.find<AddressController>();
    final mediaController = Get.find<MediaController>();

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
                      'Sales',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Sales Details section - collapsible
                  Obx(() => ExpansionTile(
                        childrenPadding: EdgeInsets.zero,
                        tilePadding:
                            const EdgeInsets.symmetric(horizontal: TSizes.sm),
                        title: Text(
                          "Sales Details",
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
                                // Cashier Info
                                const SalesCashierInfo(),
                                const SizedBox(height: TSizes.sm),

                                // Customer Info
                                SaleCustomerInfo(
                                  namesList: customerController.allCustomers
                                      .map((e) => e.fullName)
                                      .toList(),
                                  hintText: 'Customer Name',
                                  userNameTextController:
                                      controller.customerNameController,
                                  onSelectedName: (val) async {
                                    await controller
                                        .handleCustomerSelection(val);
                                  },
                                ),
                                const SizedBox(height: TSizes.sm),

                                // Salesman Info
                                const SalesSalemanInfo(),
                              ],
                            ),
                          ),
                        ],
                      )),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Product Search Section - collapsible
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
                                  // Product Bar
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(1.0),
                                    child: ProductSearchBar(
                                        productNameFocus:
                                            controller.productNameFocus),
                                  ),
                                  const SizedBox(height: TSizes.sm),

                                  // Unit Price Quantity
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(2.0),
                                    child: UnitPriceQuantity(
                                      unitPriceFocus: controller.unitPriceFocus,
                                      quantityFocus: controller.quantityFocus,
                                    ),
                                  ),
                                  const SizedBox(height: TSizes.sm),

                                  // Unit(Kg/etc) Total Price
                                  FocusTraversalOrder(
                                    order: const NumericFocusOrder(4.0),
                                    child: UnitTotalPrice(
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
                                                  onPressed:
                                                      controller.isLoading.value
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

                  // Serial Numbers Selector - collapsible if any exist
                  Obx(() => controller.hasSerialNumbers.value
                      ? ExpansionTile(
                          childrenPadding: EdgeInsets.zero,
                          tilePadding:
                              const EdgeInsets.symmetric(horizontal: TSizes.sm),
                          title: Text(
                            "Serial Numbers",
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
                              child: SerialVariantSelector(),
                            ),
                          ],
                        )
                      : const SizedBox()),

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
                                    '${controller.saleCartItem.length} item(s)',
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
                          child: Obx(() => controller.saleCartItem.isEmpty
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
                              : const SaleTable()),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Sale Summary - optimized for mobile
                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.sm),
                    child: SalesSummary(),
                  ),

                  const SizedBox(height: TSizes.md),

                  // Action buttons - full width for mobile
                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.sm),
                    child: SaleActionButtons(),
                  ),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator()));
  }
}
