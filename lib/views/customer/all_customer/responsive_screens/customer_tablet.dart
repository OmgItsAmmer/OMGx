import 'package:ecommerce_dashboard/Models/customer/customer_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/customer/customer_controller.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../table/customer_table.dart';

class CustomerTablet extends StatelessWidget {
  const CustomerTablet({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for customers
    if (!Get.isRegistered<TableSearchController>(tag: 'customers')) {
      Get.put(TableSearchController(), tag: 'customers');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'customers');
    final customerController = Get.find<CustomerController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Customers',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Table container
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add & Search - Stacked for tablet
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add button
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(TRoutes.addCustomer,
                                arguments: CustomerModel.empty());
                          },
                          child: Text(
                            'Add New Customer',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(color: TColors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      // Search field with refresh icon
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller:
                                  tableSearchController.searchController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.search_normal),
                                hintText: 'Search by name, email, or phone',
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
                              customerController.refreshCustomers();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Customer table with horizontal scroll for tablet
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 2 * TSizes.md,
                      child: const CustomerTable(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
