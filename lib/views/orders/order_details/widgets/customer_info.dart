import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_dashboard/common/widgets/containers/rounded_container.dart';
import 'package:ecommerce_dashboard/common/widgets/images/t_rounded_image.dart';
import 'package:ecommerce_dashboard/common/widgets/shimmers/shimmer.dart';
import 'package:ecommerce_dashboard/utils/constants/image_strings.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';
import 'package:ecommerce_dashboard/controllers/address/address_controller.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../controllers/customer/customer_controller.dart';
import '../../../../controllers/media/media_controller.dart';
import '../../../../controllers/salesman/salesman_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';

class UserInfo extends StatelessWidget {
  final String title;
  final String fullName; // Passed directly
  final String email; // Passed directly
  final String phoneNumber; // Passed directly
  final bool isLoading;
  final bool showAddress; // Added parameter to control showing address
  final MediaCategory mediaCategory;

  const UserInfo({
    super.key,
    required this.title,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.isLoading,
    this.showAddress = true,
    required this.mediaCategory, // Default: Show address
  });

  @override
  Widget build(BuildContext context) {
    final AddressController addressController = Get.find<AddressController>();
    final MediaController mediaController = Get.find<MediaController>();
    final CustomerController customerController =
        Get.find<CustomerController>();
    final SalesmanController salesmanController =
        Get.find<SalesmanController>();

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, // Dynamic Title
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              (mediaCategory == MediaCategory.customers)
                  ? Obx(
                      () {
                        // Fetch main image from the bucket and show it
                        return FutureBuilder<String?>(
                          future: mediaController.fetchMainImage(
                            customerController
                                    .selectedCustomer.value.customerId ??
                                -1,
                            MediaCategory.customers.toString().split('.').last,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const TShimmerEffect(
                                  width: 100,
                                  height: 100); // Show shimmer while loading
                            } else if (snapshot.hasError) {
                              return const Text(
                                  'Error loading image'); // Handle error case
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return TRoundedImage(
                                isNetworkImage: true,
                                width: 100,
                                height: 100,
                                imageurl: snapshot.data!,
                              );
                            } else {
                              return const TCircularIcon(
                                icon: Iconsax.image,
                                width: 100,
                                height: 100,
                                backgroundColor: TColors.primaryBackground,
                              ); // Handle case where no image is available
                              // Handle case where no image is available
                            }
                          },
                        );
                      },
                    )
                  : Obx(
                      () {
                        // Fetch main image from the bucket and show it
                        return FutureBuilder<String?>(
                          future: mediaController.fetchMainImage(
                            salesmanController
                                    .selectedSalesman?.value.salesmanId ??
                                -1,
                            MediaCategory.salesman.toString().split('.').last,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const TShimmerEffect(
                                  width: 80,
                                  height: 80); // Show shimmer while loading
                            } else if (snapshot.hasError) {
                              return const Text(
                                  'Error loading image'); // Handle error case
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return TRoundedImage(
                                isNetworkImage: true,
                                width: 100,
                                height: 100,
                                imageurl: snapshot.data!,
                              );
                            } else {
                              return const TCircularIcon(
                                icon: Iconsax.image,
                                width: 100,
                                height: 100,
                                backgroundColor: TColors.primaryBackground,
                              ); // Handle case where no image is available
                              // Handle case where no image is available
                            }
                          },
                        );
                      },
                    ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName, // Using fullName directly
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 2),
                    Text(
                      email, // Using email directly
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 2),
                    Text(
                      phoneNumber, // Using phoneNumber directly
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections / 2),

                    // Conditionally Render Address
                    if (showAddress)
                      Obx(() {
                        if (addressController.isLoading.value) {
                          return const TShimmerEffect(width: 20, height: 10);
                        }

                        return Text(
                          addressController.allCustomerAddresses.isNotEmpty
                              ? addressController
                                      .allCustomerAddresses[0].location ??
                                  'No Address Found'
                              : 'No Address Found',
                          style: Theme.of(context).textTheme.titleSmall,
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
