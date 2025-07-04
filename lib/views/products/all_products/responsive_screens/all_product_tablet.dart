import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../controllers/product/product_controller.dart';
import '../../../../routes/routes.dart';
import '../table/product_table.dart';

class AllProductTabletScreen extends GetView<ProductController> {
  const AllProductTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the table search controller if not already initialized
    if (!Get.isRegistered<TableSearchController>(tag: 'products')) {
      Get.put(TableSearchController(), tag: 'products');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'products');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Products', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Table Body
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add & Search Row - Stacked on tablet for better space utilization
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.cleanProductDetail();
                            Get.toNamed(TRoutes.productsDetail);
                          },
                          child: Text(
                            'Add Products',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(color: TColors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller:
                                  tableSearchController.searchController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.search_normal),
                                hintText: 'Search Anything',
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
                              controller.refreshProducts();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Table body
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 2 * TSizes.md,
                      child: const ProductTable(),
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
