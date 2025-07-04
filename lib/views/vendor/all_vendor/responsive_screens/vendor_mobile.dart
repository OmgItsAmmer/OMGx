import 'package:ecommerce_dashboard/Models/vendor/vendor_model.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/icons/t_circular_icon.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/controllers/vendor/vendor_controller.dart';
import 'package:ecommerce_dashboard/controllers/media/media_controller.dart';
import 'package:ecommerce_dashboard/controllers/table/table_search_controller.dart';
import 'package:ecommerce_dashboard/routes/routes.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/enums.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class VendorMobile extends StatelessWidget {
  const VendorMobile({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a unique instance of TableSearchController for vendors
    if (!Get.isRegistered<TableSearchController>(tag: 'vendors')) {
      Get.put(TableSearchController(), tag: 'vendors');
    }

    final tableSearchController =
        Get.find<TableSearchController>(tag: 'vendors');
    final vendorController = Get.find<VendorController>();
    final mediaController = Get.find<MediaController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Vendors',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

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
                        Get.toNamed(TRoutes.addVendor,
                            arguments: VendorModel.empty());
                      },
                      child: Text(
                        'Add New Vendor',
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
                          vendorController.refreshVendors();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Vendor Cards List
            Obx(() {
              // Get the search term from the controller
              String searchTerm =
                  tableSearchController.searchTerm.value.toLowerCase();

              // Create a filtered vendors list based on search term
              var filteredVendors = [
                ...vendorController.allVendors
              ]; // Create a copy
              if (searchTerm.isNotEmpty) {
                filteredVendors = vendorController.allVendors.where((vendor) {
                  return vendor.fullName.toLowerCase().contains(searchTerm) ||
                      vendor.email.toLowerCase().contains(searchTerm) ||
                      vendor.phoneNumber.toLowerCase().contains(searchTerm);
                }).toList();
              }

              if (filteredVendors.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Text(
                      'No vendors found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredVendors.length,
                itemBuilder: (context, index) {
                  final vendor = filteredVendors[index];
                  return VendorCard(
                    vendor: vendor,
                    mediaController: mediaController,
                    onView: () async {
                      await vendorController
                          .prepareVendorDetails(vendor.vendorId);
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

class VendorCard extends StatelessWidget {
  final VendorModel vendor;
  final MediaController mediaController;
  final VoidCallback onView;

  const VendorCard({
    Key? key,
    required this.vendor,
    required this.mediaController,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safely get vendor ID for image retrieval
    final int vendorId = vendor.vendorId is int
        ? vendor.vendorId as int
        : int.tryParse(vendor.vendorId?.toString() ?? '-1') ?? -1;

    return TRoundedContainer(
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vendor info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Vendor image
              FutureBuilder<String?>(
                future: mediaController.fetchMainImage(
                  vendorId,
                  MediaCategory.shop.toString().split('.').last,
                ),
                builder: (context, snapshot) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(TSizes.sm),
                    ),
                    child: snapshot.hasData && snapshot.data != null
                        ? TRoundedImage(
                            width: 60,
                            height: 60,
                            borderRadius: TSizes.sm,
                            imageurl: snapshot.data!,
                            isNetworkImage: true,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: TColors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(TSizes.sm),
                            ),
                            child: const Icon(
                              Iconsax.user,
                              color: TColors.darkGrey,
                              size: 30,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(width: TSizes.spaceBtwItems),

              // Vendor details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.fullName,
                      style: Theme.of(context).textTheme.titleMedium!.apply(
                            color: TColors.primary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.xs),
                    Text(
                      vendor.email,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.xs / 2),
                    Text(
                      vendor.phoneNumber,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onView,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                  ),
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: TSizes.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.find<VendorController>().selectedVendor.value = vendor;
                    Get.toNamed(TRoutes.addVendor, arguments: vendor);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                  ),
                  child: Text(
                    'Edit',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: TColors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
