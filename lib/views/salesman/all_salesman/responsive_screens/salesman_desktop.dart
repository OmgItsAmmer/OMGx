import 'package:admin_dashboard_v3/Models/salesman/salesman_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/products/all_products/table/product_table.dart';
import 'package:admin_dashboard_v3/views/salesman/all_salesman/table/salesman_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../customer/all_customer/table/customer_table.dart';

class SalesmanDesktop extends StatelessWidget {
  const SalesmanDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for salesmen
    if (!Get.isRegistered<TableSearchController>(tag: 'salesmen')) {
      Get.put(TableSearchController(), tag: 'salesmen');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'salesmen');
    final salesmanController = Get.find<SalesmanController>();

    return Expanded(
      child: SizedBox(
        //  height: 900,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Title
                Text(
                  'Salesman',
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
                                  Get.toNamed(TRoutes.addSalesman,
                                      arguments: SalesmanModel.empty());
                                },
                                child: Text(
                                  'Add New Salesman',
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
                                  salesmanController.refreshSalesman();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),
                      const SalesmanTable(),
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
