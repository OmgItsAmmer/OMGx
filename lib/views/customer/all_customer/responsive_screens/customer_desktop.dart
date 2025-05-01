import 'package:admin_dashboard_v3/Models/customer/customer_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/customer/customer_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../table/customer_table.dart';

class CustomerDesktop extends StatelessWidget {
  const CustomerDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for customers
    if (!Get.isRegistered<TableSearchController>(tag: 'customers')) {
      Get.put(TableSearchController(), tag: 'customers');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'customers');
    final customerController = Get.find<CustomerController>();

    return Expanded(
      child: SizedBox(
        //height: 900,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Title
                Text(
                  'Customers',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                //bread Crumbs

                //Table Header

                //Table
                TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                )),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 500,
                                child: TextFormField(
                                  controller:
                                      tableSearchController.searchController,
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Iconsax.search_normal),
                                      hintText:
                                          'Search by name, email, or phone'),
                                  onChanged: (value) {
                                    // Update the search term
                                    tableSearchController.searchTerm.value =
                                        value;
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
                      const SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),
                      const CustomerTable(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
