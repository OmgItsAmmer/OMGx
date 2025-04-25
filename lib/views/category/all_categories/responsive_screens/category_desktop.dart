import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Models/category/category_model.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../routes/routes.dart';
import '../table/category_table.dart';
import '../../../../controllers/search/search_controller.dart';

class AllCategoryDesktopScreen extends StatelessWidget {
  const AllCategoryDesktopScreen({super.key});

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

    return Expanded(
      child: SizedBox(
        // height: 900,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),

                //Bread Crumbs

                //Table Body
                TRoundedContainer(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
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
                          ),
                          SizedBox(
                            width: 500,
                            child: TextFormField(
                              controller:
                                  tableSearchController.searchController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Iconsax.search_normal),
                                  hintText: 'Search by category name'),
                              onChanged: (value) {
                                // Update the search term in the table controller
                                tableSearchController.searchTerm.value = value;
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),

                      //Table body
                      const CategoryTable()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
