import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../table/customer_table.dart';

class CustomerMobile extends StatelessWidget {
  const CustomerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for customers
    if (!Get.isRegistered<TableSearchController>(tag: 'customers')) {
      Get.put(TableSearchController(), tag: 'customers');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'customers');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Text(
                'Customers',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              //Table
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Field
                    TextFormField(
                      controller: tableSearchController.searchController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Iconsax.search_normal),
                          hintText: 'Search by name, email, or phone'),
                      onChanged: (value) {
                        // Update the search term
                        tableSearchController.searchTerm.value = value;
                      },
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Add Button
                    SizedBox(
                      width: double.infinity,
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
                          )),
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections),

                    const CustomerTable(),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
