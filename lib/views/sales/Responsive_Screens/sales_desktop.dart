import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/loaders/tloaders.dart';
import 'package:admin_dashboard_v3/controllers/user/user_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/products/all_products/table/product_table.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/sale_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../controllers/sales/sales_controller.dart';
import '../table/sale_table.dart';
import '../widgets/cashier_info.dart';
import '../widgets/sale_customer_info.dart';
import '../widgets/sale_product_bar.dart';
import '../widgets/sales_saleman_info.dart';
import '../widgets/sales_summary.dart';
import '../widgets/unit_price_quantity.dart';
import '../widgets/unit_total_price.dart';



class SalesDesktop extends StatelessWidget {
  const SalesDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController salesController = Get.put(SalesController());
    final UserController userController = Get.find<UserController>();
    return Expanded(
      child: SizedBox(
        // height: 900,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                ExpansionTile(
                    title: const Text(
                      "Sales Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Bind the expansion state to the controller's observable
                    initiallyExpanded: salesController.isExpanded.value,
                    onExpansionChanged: (value) {
                      salesController.toggleExpanded(); // Update the state
                    },
                    children:  [
                      Padding(
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        child: TRoundedContainer(
                          padding: const EdgeInsets.all(TSizes.defaultSpace),
                          //backgroundColor: TColors.primary,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Cashier Info
                              const Expanded(flex: 1, child: SalesCashierInfo()),
                              const SizedBox(
                                width: TSizes.spaceBtwSections, // Replace TSizes.spaceBtwSections if needed
                              ),
                                
                              // Customer Info
                              Expanded(flex: 2, child: SaleCustomerInfo(
                                suggestionsList:  userController.allUserNames,
                                hintText: 'Customer Name',
                                userNameTextController: salesController.customerNameController ,
                                onSelected: (val) {

                                  final selectedCustomer = userController.allUsers
                                      .firstWhere((user) => user.fullName == val);

                                  //Automatic gives unit price
                                  salesController.customerPhoneNoController.value.text = selectedCustomer.phoneNumber;
                                //  salesController.customerCNICController.value.text = selectedCustomer.;


                                  },

                              )),
                              const SizedBox(
                                width: TSizes.spaceBtwSections, // Replace TSizes.spaceBtwSections if needed
                              ),
                                
                              // Salesman Info
                              const Expanded(flex: 1, child: SalesSalemanInfo()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                TRoundedContainer(

                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Product Bar
                      const Expanded(child: ProductSearchBar()),
                      const SizedBox(
                        width: TSizes.spaceBtwItems,
                      ),

                      // Unit Price Quantity
                     const Expanded(child: UnitPriceQuantity()),

                      const SizedBox(
                        width: TSizes.spaceBtwItems,
                      ),
      
                      // Unit(Kg/etc) Total Price
                    const Expanded(child: UnitTotalPrice()),
      
                      // Button
                      const SizedBox(
                        width: TSizes.spaceBtwItems,
                      ),
      
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            salesController.addProduct();

                          },
                          child: const Text('Add'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections / 2,
                ),
                // Sale Table
                const TRoundedContainer(height: 530, child: SaleTable()),
                const SizedBox(
                  height: TSizes.spaceBtwSections / 2,
                ),
                const TRoundedContainer(
                  padding: EdgeInsets.all(TSizes.defaultSpace/2),
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
        ),
      ),
    );
  }
}
