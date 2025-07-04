import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Models/category/category_model.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../routes/routes.dart';
import '../table/category_table.dart';

class CategoryTablet extends StatelessWidget {
  const CategoryTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController =
        Get.find<CategoryController>();

    // Initialize the table search controller if not already initialized
    if (!Get.isRegistered<TableSearchController>(tag: 'categories')) {
      Get.put(TableSearchController(), tag: 'categories');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'categories');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Table Body
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search and Add Button Row
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Search Field
                      TextFormField(
                        controller: tableSearchController.searchController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.search_normal),
                            hintText: 'Search by category name'),
                        onChanged: (value) {
                          tableSearchController.searchTerm.value = value;
                        },
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      // Add Button
                      ElevatedButton(
                        onPressed: () {
                          categoryController.cleanCategoryDetail();
                          Get.toNamed(
                            TRoutes.categoryDetails,
                            arguments: CategoryModel.empty(),
                          );
                        },
                        child: Text(
                          'Add New Category',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .apply(color: TColors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Table
                  const CategoryTable()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
