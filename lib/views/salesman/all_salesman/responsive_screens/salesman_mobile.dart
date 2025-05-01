import 'package:admin_dashboard_v3/Models/salesman/salesman_model.dart';
import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/routes/routes.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:admin_dashboard_v3/controllers/salesman/salesman_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SalesmanMobile extends StatelessWidget {
  const SalesmanMobile({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for salesmen
    if (!Get.isRegistered<TableSearchController>(tag: 'salesmen')) {
      Get.put(TableSearchController(), tag: 'salesmen');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'salesmen');
    final salesmanController = Get.find<SalesmanController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Text(
                'Salesman',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),

              // Controls
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add button
                    SizedBox(
                      width: double.infinity,
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
                        ),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Search field with refresh icon
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: tableSearchController.searchController,
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
                            salesmanController.refreshSalesman();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              // Salesman Cards List
              Obx(() {
                // Get the search term from the controller
                String searchTerm =
                    tableSearchController.searchTerm.value.toLowerCase();

                // Create a filtered salesmen list based on search term
                var filteredSalesmen = [
                  ...salesmanController.allSalesman
                ]; // Create a copy
                if (searchTerm.isNotEmpty) {
                  filteredSalesmen =
                      salesmanController.allSalesman.where((salesman) {
                    return salesman.fullName
                            .toLowerCase()
                            .contains(searchTerm) ||
                        salesman.email.toLowerCase().contains(searchTerm) ||
                        salesman.phoneNumber.toLowerCase().contains(searchTerm);
                  }).toList();
                }

                if (filteredSalesmen.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Text(
                        'No salesmen found',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredSalesmen.length,
                  itemBuilder: (context, index) {
                    final salesman = filteredSalesmen[index];
                    return SalesmanCard(
                      salesman: salesman,
                      onView: () async {
                        await salesmanController
                            .prepareSalesmanDetails(salesman.salesmanId);
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesmanCard extends StatelessWidget {
  final SalesmanModel salesman;
  final VoidCallback onView;

  const SalesmanCard({
    Key? key,
    required this.salesman,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salesman info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Salesman avatar
              const CircleAvatar(
                radius: 30,
                child: Icon(
                  Iconsax.user,
                  size: 30,
                  color: TColors.white,
                ),
              ),
              const SizedBox(width: TSizes.sm),

              // Salesman name and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      salesman.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.xs),
                    Row(
                      children: [
                        const Icon(
                          Iconsax.sms,
                          size: 14,
                          color: TColors.white,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            salesman.email,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.sm),
          const Divider(),

          // Contact details
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              children: [
                const Icon(
                  Iconsax.call,
                  size: 16,
                  color: TColors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  salesman.phoneNumber,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              children: [
                const Icon(
                  Iconsax.location,
                  size: 16,
                  color: TColors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${salesman.area}, ${salesman.city}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
            child: Row(
              children: [
                const Icon(
                  Iconsax.card,
                  size: 16,
                  color: TColors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  salesman.cnic,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          if (salesman.comission != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.percentage_circle,
                    size: 16,
                    color: TColors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Commission: ${salesman.comission}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

          const SizedBox(height: TSizes.sm),

          // View details button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onView,
              icon: const Icon(
                Iconsax.eye,
                color: TColors.white,
              ),
              label: const Text('View Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: TColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
