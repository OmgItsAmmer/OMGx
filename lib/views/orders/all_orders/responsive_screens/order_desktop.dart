import 'package:ecommerce_dashboard/controllers/orders/orders_controller.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../table/order_table.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';

class OrdersDesktopScreen extends StatelessWidget {
  const OrdersDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize table search controller with a unique tag for orders
    if (!Get.isRegistered<TableSearchController>(tag: 'orders')) {
      Get.put(TableSearchController(), tag: 'orders');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'orders');
    final orderController = Get.find<OrderController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Orders', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Main content container
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search and filter controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Search field
                      Row(
                        children: [
                          SizedBox(
                            width: 500,
                            child: TextFormField(
                              controller:
                                  tableSearchController.searchController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.search_normal),
                                hintText: 'Search by order ID, date, or status',
                              ),
                              onChanged: (value) {
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
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Order table
                  const OrderTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
