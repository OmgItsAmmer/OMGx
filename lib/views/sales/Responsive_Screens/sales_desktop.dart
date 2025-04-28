import 'package:admin_dashboard_v3/Models/address/address_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/sale_action_buttons.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/serial_variant_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

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

class SalesDesktop extends GetView<SalesController> {
  const SalesDesktop({super.key});

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
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  // Page title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sales',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Remove ExpansionTile, keep its content
                  // ExpansionTile(
                  //   title: const Text(
                  //     "Sales Details",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  //   // Bind the expansion state to the controller's observable
                  //   initiallyExpanded: controller.isExpanded.value,
                  //   onExpansionChanged: (value) {
                  //     controller.toggleExpanded(); // Update the state
                  //   },
                  //   children: [
                  Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: TRoundedContainer(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cashier Info
                          const Expanded(flex: 1, child: SalesCashierInfo()),
                          const SizedBox(
                            width: TSizes.spaceBtwSections,
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

                                ///ADDRESS RELATED
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
                              )),

                          const SizedBox(
                            width: TSizes.spaceBtwSections,
                          ),

                          // Salesman Info
                          const Expanded(flex: 1, child: SalesSalemanInfo()),
                        ],
                      ),
                    ),
                  ),
                  //   ],
                  // ),

                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
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
                                  color: TColors.dark.withOpacity(0.8),
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
                                          activeTrackColor:
                                              TColors.primary.withOpacity(0.5),
                                          inactiveThumbColor: TColors.grey,
                                          inactiveTrackColor:
                                              TColors.grey.withOpacity(0.5),
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
                          // Use OrderedTraversalPolicy. Widgets within must be wrapped by FocusTraversalOrder.
                          policy: OrderedTraversalPolicy(),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Product Bar - Wrap with FocusTraversalOrder
                              Expanded(
                                  child: FocusTraversalOrder(
                                order: const NumericFocusOrder(1.0),
                                child: ProductSearchBar(
                                    productNameFocus:
                                        controller.productNameFocus),
                              )),
                              const SizedBox(
                                width: TSizes.spaceBtwItems,
                              ),

                              // Unit Price Quantity - Wrap with FocusTraversalOrder (contains two focus nodes)
                              // Note: Internal order within UnitPriceQuantity is handled by default LTR
                              Expanded(
                                  child: FocusTraversalOrder(
                                order: const NumericFocusOrder(
                                    2.0), // Order for the whole widget group
                                child: UnitPriceQuantity(
                                  unitPriceFocus: controller.unitPriceFocus,
                                  quantityFocus: controller.quantityFocus,
                                ),
                              )),
                              const SizedBox(
                                width: TSizes.spaceBtwItems,
                              ),

                              // Unit(Kg/etc) Total Price - Wrap with FocusTraversalOrder
                              Expanded(
                                  child: FocusTraversalOrder(
                                order: const NumericFocusOrder(
                                    4.0), // Order for the whole widget group
                                child: UnitTotalPrice(
                                    totalPriceFocus:
                                        controller.totalPriceFocus),
                              )),
                              const SizedBox(
                                width: TSizes.spaceBtwItems,
                              ),

                              // Add Button - Wrap with FocusTraversalOrder
                              Expanded(
                                child: FocusTraversalOrder(
                                  order: const NumericFocusOrder(5.0),
                                  child: SizedBox(
                                    height:
                                        58, // Match approximate TextFormField height
                                    width: double.infinity,
                                    child: Obx(() => ElevatedButton(
                                          focusNode: controller.addButtonFocus,
                                          onPressed: controller.isLoading.value
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
                              const SizedBox(
                                width: TSizes.spaceBtwItems,
                              ),
                              // Reset Button
                              TCircularIcon(
                                icon: Iconsax.refresh,
                                backgroundColor:
                                    TColors.primary.withOpacity(0.1),
                                color: TColors.primary,
                                // tooltip: 'Reset Fields', // Removed tooltip
                                onPressed: () {
                                  // Reset product form fields
                                  controller
                                      .resetFields(); // Use original resetFields
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
                  const SizedBox(
                    height: TSizes.spaceBtwSections / 2,
                  ),

                  // Serial Numbers Selector (for products with serial numbers)
                  const SerialVariantSelector(),

                  const SizedBox(
                    height: TSizes.spaceBtwSections / 2,
                  ),

                  // Sale Table
                  const TRoundedContainer(height: 530, child: SaleTable()),
                  const SizedBox(
                    height: TSizes.spaceBtwSections / 2,
                  ),
                  const TRoundedContainer(
                    padding: EdgeInsets.all(TSizes.defaultSpace / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: SaleActionButtons()),
                        Expanded(flex: 2, child: SalesSummary()),
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
