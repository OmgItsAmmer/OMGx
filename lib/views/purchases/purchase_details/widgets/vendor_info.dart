import 'package:admin_dashboard_v3/common/widgets/containers/rounded_container.dart';
import 'package:admin_dashboard_v3/common/widgets/images/t_rounded_image.dart';
import 'package:admin_dashboard_v3/common/widgets/shimmers/shimmer.dart';
import 'package:admin_dashboard_v3/controllers/address/address_controller.dart';
import 'package:admin_dashboard_v3/controllers/media/media_controller.dart';
import 'package:admin_dashboard_v3/utils/constants/colors.dart';
import 'package:admin_dashboard_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/enums.dart';

class VendorInfo extends StatelessWidget {
  const VendorInfo({
    super.key,
    required this.mediaCategory,
    required this.title,
    required this.showAddress,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isLoading,
  });

  final MediaCategory mediaCategory;
  final String title;
  final bool showAddress;
  final String fullName;
  final String email;
  final String phoneNumber;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final MediaController mediaController = Get.find<MediaController>();
    final AddressController addressController = Get.find<AddressController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Loading state
          if (isLoading)
            const Column(
              children: [
                TShimmerEffect(width: double.infinity, height: 80),
                SizedBox(height: TSizes.spaceBtwItems),
                TShimmerEffect(width: double.infinity, height: 60),
                SizedBox(height: TSizes.spaceBtwItems),
                TShimmerEffect(width: double.infinity, height: 60),
              ],
            )
          else
            Column(
              children: [
                // User Image and Basic Info
                Row(
                  children: [
                    // Profile Image
                    FutureBuilder<String?>(
                      future: fullName != 'Not Found'
                          ? mediaController.fetchMainImage(
                              0, // Using 0 as placeholder - adjust based on your vendor ID system
                              mediaCategory.toString().split('.').last,
                            )
                          : Future.value(null),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const TShimmerEffect(
                              width: 60, height: 60, radius: 50);
                        } else if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data == null) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: TColors.primaryBackground,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Iconsax.user,
                              size: 30,
                              color: TColors.primary,
                            ),
                          );
                        } else {
                          return TRoundedImage(
                            isNetworkImage: true,
                            width: 60,
                            height: 60,
                            imageurl: snapshot.data!,
                            borderRadius: 50,
                          );
                        }
                      },
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),

                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Iconsax.call,
                                size: 16,
                                color: TColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  phoneNumber,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Iconsax.sms,
                                size: 16,
                                color: TColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  email,
                                  style: Theme.of(context).textTheme.bodyMedium,
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

                // Address section
                if (showAddress) ...[
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Iconsax.location,
                        size: 20,
                        color: TColors.primary,
                      ),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Obx(() {
                              if (addressController.isLoading.value) {
                                return const TShimmerEffect(
                                    width: double.infinity, height: 40);
                              } else if (addressController
                                  .allVendorAddresses.isEmpty) {
                                return Text(
                                  'No address found',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                );
                              } else {
                                final address =
                                    addressController.allVendorAddresses.first;
                                return Text(
                                  address.location ?? 'No location specified',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
