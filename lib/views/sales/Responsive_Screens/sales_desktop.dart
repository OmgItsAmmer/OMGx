import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/products/all_products/table/product_table.dart';
import 'package:admin_dashboard_v3/views/sales/widgets/sale_action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../table/sale_table.dart';
import '../widgets/cashier_info.dart';
import '../widgets/sale_customer_info.dart';
import '../widgets/sale_product_bar.dart';
import '../widgets/sales_saleman_info.dart';
import '../widgets/sales_summary.dart';
import '../widgets/unit_price_quantity.dart';
import '../widgets/unit_total_price.dart';

// Controller to manage the state
class SalesController extends GetxController {
  // Reactive variable to track expansion state
  var isExpanded = true.obs;

  // Toggle the expansion state
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }
}

class SalesDesktop extends StatelessWidget {
  const SalesDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final SalesController controller = Get.put(SalesController());
    return SizedBox(
      height: 900,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Obx(
                // Wrap with Obx to reactively update on state change
                    () => ExpansionTile(
                  title: const Text(
                    "Sales Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Bind the expansion state to the controller's observable
                  initiallyExpanded: controller.isExpanded.value,
                  onExpansionChanged: (value) {
                    controller.toggleExpanded(); // Update the state
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(TSizes.defaultSpace),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cashier Info
                          Expanded(flex: 1, child: SalesCashierInfo()),
                          SizedBox(
                            width: 16.0, // Replace TSizes.spaceBtwSections if needed
                          ),

                          // Customer Info
                          Expanded(flex: 2, child: SaleCustomerInfo()),
                          SizedBox(
                            width: 16.0, // Replace TSizes.spaceBtwSections if needed
                          ),

                          // Salesman Info
                          Expanded(flex: 1, child: SalesSalemanInfo()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              TRoundedContainer(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Bar
                    const ProductSearchBar(),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    // Unit Price Quantity
                    const UnitPriceQuantity(),
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),

                    // Unit(Kg/etc) Total Price
                    const UnitTotalPrice(),

                    // Button
                    const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
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
    );
  }
}
