import 'package:admin_dashboard_v3/common/widgets/texts/section_heading.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/enums.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/containers/rounded_container.dart';
import '../table/order_table.dart';

class OrdersDesktopScreen extends StatelessWidget {
  const OrdersDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for orders
    if (!Get.isRegistered<TableSearchController>(tag: 'orders')) {
      Get.put(TableSearchController(), tag: 'orders');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'orders');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Bread crumbs
            Text(
              'Orders',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            //Table Body
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add search bar
                  SizedBox(
                    width: 500,
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
