import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/icons/t_circular_icon.dart';
import 'package:admin_dashboard_v3/controllers/brands/brand_controller.dart';
import 'package:admin_dashboard_v3/controllers/table/table_search_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../Models/brand/brand_model.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../routes/routes.dart';

class AllBrandsMobileScreen extends StatelessWidget {
  const AllBrandsMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BrandController brandController = Get.find<BrandController>();
    final MediaController mediaController = Get.find<MediaController>();

    // Initialize the table search controller with a tag for brands
    if (!Get.isRegistered<TableSearchController>(tag: 'brands')) {
      Get.put(TableSearchController(), tag: 'brands');
    }
    final tableSearchController =
        Get.find<TableSearchController>(tag: 'brands');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Brands',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Controls Section
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add button - full width for mobile
                  SizedBox(
                    width: double.infinity,
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

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // Search field with refresh icon
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: tableSearchController.searchController,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Iconsax.search_normal),
                              hintText: 'Search by brand name'),
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
                          brandController.refreshBrands();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // Brand Cards
            Obx(() {
              // Get the search term from the controller
              String searchTerm =
                  tableSearchController.searchTerm.value.toLowerCase();

              // Create a filtered brands list based on search term
              var filteredBrands = [
                ...brandController.allBrands
              ]; // Create a copy
              if (searchTerm.isNotEmpty) {
                filteredBrands = brandController.allBrands.where((brand) {
                  final brandName = brand.bname?.toLowerCase() ?? '';
                  return brandName.contains(searchTerm);
                }).toList();
              }

              if (filteredBrands.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Text(
                      'No brands found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredBrands.length,
                itemBuilder: (context, index) {
                  final brand = filteredBrands[index];
                  return BrandCard(
                    brand: brand,
                    mediaController: mediaController,
                    onEdit: () {
                      brandController.setBrandDetail(brand);
                      brandController.selectedBrand.value = brand;
                      Get.toNamed(TRoutes.brandDetails, arguments: brand);
                    },
                    onDelete: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text(
                              'Are you sure you want to delete ${brand.bname}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && brand.brandID != null) {
                        await brandController.deleteBrand(brand.brandID!);
                      }
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class BrandCard extends StatelessWidget {
  final BrandModel brand;
  final MediaController mediaController;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BrandCard({
    Key? key,
    required this.brand,
    required this.mediaController,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand name row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Brand icon
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: TColors.primary,
                      child: Icon(
                        Iconsax.shop,
                        color: TColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: TSizes.sm),

                    // Brand name and badges
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  brand.bname ?? 'Unnamed Brand',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (brand.isVerified)
                                const Icon(
                                  Icons.verified,
                                  color: TColors.primary,
                                  size: 20,
                                ),
                              if (brand.isFeatured == true)
                                const Padding(
                                  padding: EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.star,
                                    color: TColors.warning,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: TSizes.xs),
                          Text(
                            '${brand.productsCount ?? 0} Products',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.md),
          const Divider(),
          const SizedBox(height: TSizes.xs),

          // Status indicators
          Wrap(
            spacing: TSizes.sm,
            children: [
              Chip(
                backgroundColor: brand.isVerified
                    ? TColors.success.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                label: Text(
                  brand.isVerified ? 'Verified' : 'Unverified',
                  style: TextStyle(
                    color: brand.isVerified ? TColors.success : Colors.grey,
                  ),
                ),
                avatar: Icon(
                  brand.isVerified ? Iconsax.verify : Iconsax.close_circle,
                  size: 16,
                  color: brand.isVerified ? TColors.success : Colors.grey,
                ),
              ),
              Chip(
                backgroundColor: brand.isFeatured == true
                    ? TColors.warning.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                label: Text(
                  brand.isFeatured == true ? 'Featured' : 'Not Featured',
                  style: TextStyle(
                    color: brand.isFeatured == true
                        ? TColors.warning
                        : Colors.grey,
                  ),
                ),
                avatar: Icon(
                  brand.isFeatured == true ? Iconsax.star : Iconsax.star1,
                  size: 16,
                  color:
                      brand.isFeatured == true ? TColors.warning : Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: TSizes.md),

          // Action buttons
          Row(
            children: [
              // Edit button
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(
                    Iconsax.edit,
                    color: TColors.white,
                  ),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: TColors.white,
                  ),
                ),
              ),
              const SizedBox(width: TSizes.sm),

              // Delete button
              Expanded(
                child: TCircularIcon(
                  onPressed: onDelete,
                  icon: Iconsax.trash,
                  color: TColors.white,
                  backgroundColor: TColors.error,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
