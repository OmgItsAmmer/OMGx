import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/orders/orders_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../table/order_table.dart';

class OrdersTabletScreen extends StatelessWidget {
  const OrdersTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for orders
    if (!Get.isRegistered<TableSearchController>(tag: 'orders')) {
      Get.put(TableSearchController(), tag: 'orders');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'orders');
    final orderController = Get.find<OrderController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orders',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            //Table Body
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add search bar
                  Row(
                    children: [
                      SizedBox(
                        width: 400,
                        child: TextFormField(
                          controller: tableSearchController.searchController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.search_normal),
                            hintText: 'Search by order ID, customer, or status',
                          ),
                          onChanged: (value) {
                            // Update the search term
                            tableSearchController.searchTerm.value = value;
                          },
                        ),
                      ),
                      const SizedBox(width: TSizes.sm),
                      TCircularIcon(
                        icon: Iconsax.refresh,
                        backgroundColor: TColors.primary,
                        color: TColors.white,
                        onPressed: () {
                          orderController.fetchOrders();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  const OrderTable(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
