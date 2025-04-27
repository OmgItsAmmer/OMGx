import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/sale_action_buttons.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/sales_chart.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/sales_stats.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/recent_sales.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/serial_variant_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

                  ExpansionTile(
                    title: const Text(
                      "Sales Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    initiallyExpanded: controller.isExpanded.value,
                    onExpansionChanged: (value) {
                      controller.toggleExpanded();
                    },
                    children: [
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
                                        namesList: customerController
                                            .allCustomers
                                            .map((e) => e.fullName)
                                            .toList(),
                                        hintText: 'Customer Name',
                                        userNameTextController:
                                            controller.customerNameController,
                                        onSelectedName: (val) async {
                                          if (val.isEmpty) {
                                            customerController.selectedCustomer
                                                .value = CustomerModel.empty();
                                            controller
                                                .customerPhoneNoController.value
                                                .clear();
                                            controller
                                                .customerCNICController.value
                                                .clear();
                                            addressController
                                                .selectedCustomerAddress
                                                .value = AddressModel.empty();
                                            controller
                                                .customerAddressController.value
                                                .clear();
                                            controller.selectedAddressId = null;
                                            mediaController.displayImage.value =
                                                null;
                                            return;
                                          }

                                          // Continue normal logic
                                          customerController
                                                  .selectedCustomer.value =
                                              customerController.allCustomers
                                                  .firstWhere((user) =>
                                                      user.fullName == val);
                                          addressController
                                              .fetchEntityAddresses(
                                                  customerController
                                                      .selectedCustomer
                                                      .value
                                                      .customerId!,
                                                  'Customer');
                                          controller.entityId.value =
                                              customerController
                                                  .selectedCustomer
                                                  .value
                                                  .customerId!;
                                          controller.customerPhoneNoController
                                                  .value.text =
                                              customerController
                                                  .selectedCustomer
                                                  .value
                                                  .phoneNumber;
                                          controller.customerCNICController
                                                  .value.text =
                                              customerController
                                                  .selectedCustomer.value.cnic;
                                        },
                                        addressList: addressController
                                            .allCustomerAddressesLocation,
                                        addressTextController: controller
                                            .customerAddressController.value,
                                        onSelectedAddress: (val) {
                                          addressController
                                                  .selectedCustomerAddress
                                                  .value =
                                              addressController
                                                  .allCustomerAddresses
                                                  .firstWhere((address) =>
                                                      address.location == val);

                                          controller.selectedAddressId =
                                              addressController
                                                  .selectedCustomerAddress
                                                  .value
                                                  .addressId;
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
                    ],
                  ),

                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  // Product Search Section
                  TRoundedContainer(
                    padding: const EdgeInsets.all(TSizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First row: Product Bar and Unit Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Product Bar
                            const Expanded(flex: 2, child: ProductSearchBar()),
                            const SizedBox(
                              width: TSizes.spaceBtwItems,
                            ),

                            // Unit Price Quantity
                            const Expanded(child: UnitPriceQuantity()),
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
                            const Expanded(child: UnitTotalPrice()),

                            const SizedBox(
                              width: TSizes.spaceBtwItems,
                            ),

                            // Add Button
                            Expanded(
                              child: Obx(() => ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () => controller.addProduct(),
                                    child: controller.isLoading.value
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(),
                                          )
                                        : const Text('Add'),
                                  )),
                            ),
                          ],
                        ),
                      ],
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
