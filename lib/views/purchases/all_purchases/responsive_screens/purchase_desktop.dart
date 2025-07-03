import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/purchase/purchase_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/views/purchases/all_purchases/table/purchase_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PurchasesDesktopScreen extends StatelessWidget {
  const PurchasesDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize table search controller with a unique tag for purchases
    if (!Get.isRegistered<TableSearchController>(tag: 'purchases')) {
      Get.put(TableSearchController(), tag: 'purchases');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'purchases');
    final purchaseController = Get.find<PurchaseController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Purchases',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Main content container
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search and filter controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Search field
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
                                    'Search by purchase ID, date, or status',
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
                              purchaseController.fetchPurchases();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Purchase table
                  const PurchaseTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
