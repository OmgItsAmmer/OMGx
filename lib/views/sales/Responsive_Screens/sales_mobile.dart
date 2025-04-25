import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/sale_action_buttons.dart';
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

                  // Sales Details
                  ExpansionTile(
                    title: const Text(
                      "Sales Details",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    initiallyExpanded: controller.isExpanded.value,
                    onExpansionChanged: (value) {
                      controller.toggleExpanded();
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(TSizes.sm),
                        child: TRoundedContainer(
                          padding: const EdgeInsets.all(TSizes.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Cashier Info
                              const SalesCashierInfo(),

                              const SizedBox(
                                height: TSizes.spaceBtwItems,
                              ),

                              // Customer Info
                              SaleCustomerInfo(
                                namesList: customerController.allCustomers
                                    .map((e) => e.fullName)
                                    .toList(),
                                hintText: 'Customer Name',
                                userNameTextController:
                                    controller.customerNameController,
                                onSelectedName: (val) async {
                                  if (val.isEmpty) {
                                    customerController.selectedCustomer.value =
                                        CustomerModel.empty();
                                    controller.customerPhoneNoController.value
                                        .clear();
                                    controller.customerCNICController.value
                                        .clear();
                                    addressController.selectedCustomerAddress
                                        .value = AddressModel.empty();
                                    controller.customerAddressController.value
                                        .clear();
                                    controller.selectedAddressId = null;
                                    mediaController.displayImage.value = null;
                                    return;
                                  }

                                  // Continue normal logic
                                  customerController.selectedCustomer.value =
                                      customerController.allCustomers
                                          .firstWhere(
                                              (user) => user.fullName == val);
                                  addressController.fetchEntityAddresses(
                                      customerController
                                          .selectedCustomer.value.customerId!,
                                      'Customer');
                                  controller.entityId.value = customerController
                                      .selectedCustomer.value.customerId!;
                                  controller.customerPhoneNoController.value
                                          .text =
                                      customerController
                                          .selectedCustomer.value.phoneNumber;
                                  controller.customerCNICController.value.text =
                                      customerController
                                          .selectedCustomer.value.cnic;
                                },
                                addressList: addressController
                                    .allCustomerAddressesLocation,
                                addressTextController:
                                    controller.customerAddressController.value,
                                onSelectedAddress: (val) {
                                  addressController
                                          .selectedCustomerAddress.value =
                                      addressController.allCustomerAddresses
                                          .firstWhere((address) =>
                                              address.location == val);

                                  controller.selectedAddressId =
                                      addressController.selectedCustomerAddress
                                          .value.addressId;
                                },
                              ),

                              const SizedBox(
                                height: TSizes.spaceBtwItems,
                              ),

                              // Salesman Info
                              const SalesSalemanInfo(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  // Product Search Section
                  TRoundedContainer(
                    padding: const EdgeInsets.all(TSizes.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Bar
                        const ProductSearchBar(),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),

                        // Unit Price Quantity
                        const UnitPriceQuantity(),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),

                        // Unit(Kg/etc) Total Price
                        const UnitTotalPrice(),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),

                        // Add Button
                        SizedBox(
                          width: double.infinity,
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
                  ),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  // Serial Numbers Selector (for products with serial numbers)
                  const SerialVariantSelector(),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  // Sale Table - smaller height for mobile
                  const TRoundedContainer(height: 350, child: SaleTable()),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  // Action buttons and summary in separate containers
                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.sm),
                    child: SaleActionButtons(),
                  ),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.sm),
                    child: SalesSummary(),
                  ),
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator()));
  }
}
