import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/collection/collection_controller.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../routes/routes.dart';
import '../table/collection_table.dart';

class AllCollectionsMobileScreen extends GetView<CollectionController> {
  const AllCollectionsMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the table search controller if not already initialized
    if (!Get.isRegistered<TableSearchController>(tag: 'collections')) {
      Get.put(TableSearchController(), tag: 'collections');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'collections');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Collections', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Add Collection Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.clearForm();
                  Get.toNamed(TRoutes.collectionDetails);
                },
                child: Text(
                  'Add Collection',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .apply(color: TColors.white),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: tableSearchController.searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.search_normal),
                      hintText: 'Search Collections',
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
                    controller.fetchCollections();
                  },
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            //Table Body
            const TRoundedContainer(
              padding: EdgeInsets.all(TSizes.sm),
              child: CollectionTable(),
            ),
          ],
        ),
      ),
    );
  }
}
