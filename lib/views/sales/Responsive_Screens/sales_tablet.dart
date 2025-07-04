import 'package:ecommerce_dashboard/Models/address/address_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/address/address_controller.dart';
import 'package:ecommerce_dashboard/controllers/customer/customer_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/views/sales/widgets/sale_action_buttons.dart';
import 'package:ecommerce_dashboard/views/sales/widgets/sales_chart.dart';
import 'package:ecommerce_dashboard/views/sales/widgets/sales_stats.dart';
import 'package:ecommerce_dashboard/views/sales/widgets/recent_sales.dart';
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

class SalesTablet extends GetView<SalesController> {
  const SalesTablet({super.key});

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
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                children: [
                  // Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sales',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  // const SizedBox(height: TSizes.spaceBtwSections),

                  // // Sales Stats
                  // const SalesStats(),
                  // const SizedBox(height: TSizes.spaceBtwSections),

                  // // Sales Chart
                  // const SalesChart(),
                  // const SizedBox(height: TSizes.spaceBtwSections),

                  // // Recent Sales
                  // const RecentSales(),

                  // Remove ExpansionTile, keep its content
                  // ExpansionTile(
                  //   title: const Text(
                  //     "Sales Details",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  //   initiallyExpanded: controller.isExpanded.value,
                  //   onExpansionChanged: (value) {
                  //     controller.toggleExpanded();
                  //   },
                  //   children: [
                  Padding(
                    padding: const EdgeInsets.all(TSizes.md),
                    child: TRoundedContainer(
                      padding: const EdgeInsets.all(TSizes.md),
                      child: Column(
                        children: [
                          // First row: Cashier and Customer Info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Cashier Info
                              const Expanded(
                                  flex: 1, child: SalesCashierInfo()),
                              const SizedBox(
                                width: TSizes.spaceBtwItems,
                              ),

                              // Customer Info
                              Expanded(
                                  flex: 2,
                                  child: SaleCustomerInfo(
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
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: TSizes.spaceBtwItems,
                          ),
                          // Second row: Salesman Info
                          const SalesSalemanInfo(),
                        ],
                      ),
                    ),
                  ),
                  //   ],
                  // ),

                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  // Product Search Section
                  TRoundedContainer(
                    padding: const EdgeInsets.all(TSizes.md),
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First row: Product Bar and Unit Price/Quantity
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Product Bar
                              Expanded(
                                  flex: 2,
                                  child: FocusTraversalOrder(
                                    order: const NumericFocusOrder(1.0),
                                    child: ProductSearchBar(
                                        productNameFocus:
                                            controller.productNameFocus),
                                  )),
                              const SizedBox(
                                width: TSizes.spaceBtwItems,
                              ),

                              // Unit Price Quantity
                              Expanded(
                                  child: FocusTraversalOrder(
                                order: const NumericFocusOrder(2.0),
                                child: UnitPriceQuantity(
                                  unitPriceFocus: controller.unitPriceFocus,
                                  quantityFocus: controller.quantityFocus,
                                ),
                              )),
                            ],
                          ),

                          const SizedBox(
                            height: TSizes.spaceBtwItems,
                          ),

                          // Second row: Total Price and Add Button
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Unit(Kg/etc) Total Price
                              Expanded(
                                  child: FocusTraversalOrder(
                                order: const NumericFocusOrder(4.0),
                                child: UnitTotalPrice(
                                    totalPriceFocus:
                                        controller.totalPriceFocus),
                              )),

                              const SizedBox(
                                width: TSizes.spaceBtwItems,
                              ),

                              // Add Button
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: FocusTraversalOrder(
                                        // Wrap button
                                        order: const NumericFocusOrder(5.0),
                                        child: Obx(() => ElevatedButton(
                                              focusNode: controller
                                                  .addButtonFocus, // Assign focus node
                                              onPressed: controller
                                                      .isLoading.value
                                                  ? null
                                                  : () {
                                                      controller.addProduct();
                                                      // Request focus after adding
                                                      controller
                                                          .productNameFocus
                                                          .requestFocus();
                                                    },
                                              child: controller.isLoading.value
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
                                        // Reset product form fields
                                        controller.resetFields();
                                        // Request focus after resetting
                                        controller.productNameFocus
                                            .requestFocus();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  // Serial Numbers Selector
                  const SerialVariantSelector(),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  // Sale Table
                  const TRoundedContainer(height: 400, child: SaleTable()),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  // Action buttons
                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.md),
                    child: SaleActionButtons(),
                  ),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  // Summary
                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.md),
                    child: SalesSummary(),
                  ),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator()));
  }
}
