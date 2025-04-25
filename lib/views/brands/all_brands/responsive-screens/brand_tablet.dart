import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/brands/all_brands/table/brand_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Models/brand/brand_model.dart';
import '../../../../routes/routes.dart';

class AllBrandsTabletScreen extends StatelessWidget {
  const AllBrandsTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandController brandController = Get.find<BrandController>();

    // Initialize the table search controller with a tag for brands
    if (!Get.isRegistered<TableSearchController>(tag: 'brands')) {
      Get.put(TableSearchController(), tag: 'brands');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'brands');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Brands',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Table Body
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // For tablet, we can keep a row layout but adjust spacing
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Add button
                      SizedBox(
                        width: 180, // Adjusted width for tablet
                        child: ElevatedButton(
                          onPressed: () {
                            brandController.cleanBrandDetail();
                            Get.toNamed(TRoutes.brandDetails,
                                arguments: BrandModel.empty());
                          },
                          child: Text(
                            'Add New Brand',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(color: TColors.white),
                          ),
                        ),
                      ),

                      // Search field - adjusted width for tablet
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: tableSearchController.searchController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.search_normal),
                              hintText: 'Search by brand name'),
                          onChanged: (value) {
                            tableSearchController.searchTerm.value = value;
                          },
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Brand table - same as desktop but with adjusted padding
                  const BrandTable()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
